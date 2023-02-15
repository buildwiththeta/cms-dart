part of 'index.dart';

/// bye
class RealtimeHandler {
  /// bye
  RealtimeHandler(
    this.action,
    this.collection,
    this.document,
    this.callback,
    this.off,
  );

  /// bye
  String collection;

  /// bye
  String document;

  /// bye
  StreamAction action;

  /// bye
  Function(SocketChangeEvent) callback;

  /// bye
  Function() off;
}

bool _matchColl(final String cColl, final String sColl) {
  if (cColl == '*') return true;
  return cColl == sColl;
}

bool _matchDoc(final String cDoc, final String? sDoc) {
  if (sDoc == null) return true;
  if (cDoc == '*') return true;
  return cDoc == sDoc;
}

bool _matchAction(
    final StreamAction cAction, final String sAction, final String sType) {
  if (cAction == StreamAction.all) return true;

  if (cAction == StreamAction.createCollection) {
    return sType == 'collection' && sAction == 'create';
  } else if (cAction == StreamAction.createDoc) {
    return sType == 'document' && sAction == 'create';
  } else if (cAction == StreamAction.updateCollection) {
    return sType == 'collection' && sAction == 'edit';
  } else if (cAction == StreamAction.updateDoc) {
    return sType == 'document' && sAction == 'edit';
  } else if (cAction == StreamAction.deleteCollection) {
    return sType == 'collection' && sAction == 'delete';
  } else if (cAction == StreamAction.deleteDoc) {
    return sType == 'document' && sAction == 'delete';
  }

  return false;
}

/// Teta Realtime
@lazySingleton
class TetaRealtime {
  ///Constructor
  TetaRealtime(
    this._serverRequestMetadata,
  );

  socket_io.Socket? _socket;

  ///This stores the token and project id headers.
  final ServerRequestMetadataStore _serverRequestMetadata;

  /// List of all the streams
  List<RealtimeHandler> handlers = [];

  Future<void> _openSocket() {
    final completer = Completer<void>();

    if (_socket?.connected == true) {
      completer.complete();
      return completer.future;
    }

    final opts = socket_io.OptionBuilder()
        .setPath('/cms_stream')
        .setTransports(['websocket'])
        .disableAutoConnect()
        .build();

    _socket = socket_io.io(Constants.tetaUrl, opts);

    _socket?.onConnect((final dynamic _) {
      TetaCMS.printWarning('Socket Connected');
      completer.complete();
    });

    _socket?.on('event', (final dynamic data) {
      TetaCMS.printError('Socket Event: $data');
      final event = SocketChangeEvent.fromJson(data as Map<String, dynamic>);

      for (final handler in handlers) {
        final matchingAction =
            _matchAction(handler.action, event.action, event.type);
        final matchingDoc = _matchDoc(handler.document, event.documentId);
        final matchingColl = _matchColl(handler.collection, event.collectionId);
        if (!matchingAction) return;
        if (!matchingDoc) return;
        if (!matchingColl) return;
        TetaCMS.printWarning('Calling Hand: ${handler.action}');
        handler.callback(event);
      }
    });

    _socket!.connect();

    return completer.future;
  }

  void _off(final RealtimeHandler _handler) {
    final handler = handlers.firstWhere((final h) => h == _handler);
    handlers.remove(handler);

    if (handlers.isEmpty) {
      _socket!.close();
      _socket = null;
    }
  }

  /// Creates a websocket connection to the NoSql database
  /// that listens for events of type [action] and
  /// fires [callback] when the event is emitted.
  ///
  /// Returns a `NoSqlStream`
  ///
  Future<RealtimeHandler> on({
    final StreamAction action = StreamAction.all,
    final String? collectionId,
    final String? documentId,
    final Function(SocketChangeEvent)? callback,
  }) async {
    final serverMetadata = _serverRequestMetadata.getMetadata();

    if (_socket == null) await _openSocket();

    TetaCMS.printWarning('Socket Id: ${_socket!.id}');

    final collId = collectionId ?? '*';
    final docId = action.targetDocument ? documentId : '*';
    if (docId == null) throw Exception('documentId is required');

    _socket?.emit('sub', serverMetadata.prjId);

    final handler =
        RealtimeHandler(action, collId, docId, callback!, () => null);
    handler.off = () => _off(handler);

    handlers.add(handler);

    return handler;
  }

  /// Creates a websocket connection to the NoSql database
  /// that listens for events of type [action]
  ///
  /// Returns a `Stream<SocketChangeEvent>`
  ///
  StreamController<SocketChangeEvent> stream({
    final StreamAction action = StreamAction.all,
    final String? collectionId,
    final String? documentId,
  }) {
    final streamController = StreamController<SocketChangeEvent>();
    on(
      collectionId: collectionId,
      callback: (final e) async* {
        streamController.add(e);
      },
    );
    return streamController;
  }

  /// Stream all collections without docs
  StreamController<List<CollectionObject>> streamCollections({
    final StreamAction action = StreamAction.all,
  }) {
    late final StreamController<List<CollectionObject>> streamController;
    streamController = StreamController<List<CollectionObject>>.broadcast(
      onCancel: () {
        if (!streamController.hasListener) {
          streamController.close();
        }
      },
    );
    TetaCMS.instance.analytics.insertEvent(
      TetaAnalyticsType.streamCollection,
      'Teta CMS: realtime request',
      <String, dynamic>{},
      isUserIdPreferableIfExists: true,
    );
    TetaCMS.instance.client.getCollections().then(
      (final e) {
        if (e.error == null) {
          streamController.add(e.data!);
        }
      },
    );
    on(
      callback: (final e) async {
        TetaCMS.log('on stream collections event. $e');
        final resp = await TetaCMS.instance.client.getCollections();
        TetaCMS.log('on resp get collections: $resp');
        if (resp.error == null) {
          streamController.add(resp.data!);
        }
      },
    );
    return streamController;
  }

  /// Stream a single collection with its docs only
  StreamController<List<dynamic>> streamCollection(
    final String collectionId, {
    final StreamAction action = StreamAction.all,
    final List<Filter> filters = const [],
    final int page = 0,
    final int limit = 20,
    final bool showDrafts = false,
  }) {
    late final StreamController<List<dynamic>> streamController;
    streamController = StreamController<List<dynamic>>.broadcast(
      onCancel: () {
        if (!streamController.hasListener) {
          streamController.close();
        }
      },
    );
    TetaCMS.instance.analytics.insertEvent(
      TetaAnalyticsType.streamCollection,
      'Teta CMS: realtime request',
      <String, dynamic>{},
      isUserIdPreferableIfExists: true,
    );
    TetaCMS.instance.client
        .getCollection(
      collectionId,
      filters: filters,
      limit: limit,
      page: page,
      showDrafts: showDrafts,
    )
        .then(
      (final e) {
        TetaCMS.printWarning('${e.error}, ${e.data}');
        if (e.error == null) {
          streamController.add(e.data!);
        }
      },
    );
    on(
      collectionId: collectionId,
      callback: (final e) async {
        try {
          unawaited(
            TetaCMS.instance.analytics.insertEvent(
              TetaAnalyticsType.streamCollection,
              'Teta CMS: realtime request',
              <String, dynamic>{},
              isUserIdPreferableIfExists: true,
            ),
          );
        } catch (_) {}
        final resp = await TetaCMS.instance.client.getCollection(
          collectionId,
          filters: filters,
          limit: limit,
          page: page,
          showDrafts: showDrafts,
        );
        if (resp.error == null) {
          streamController.add(resp.data!);
        }
      },
    );
    return streamController;
  }

  /// Stream a single collection with its docs only
  StreamController<List<dynamic>> streamCollectionByName(
    final String collectionName, {
    final StreamAction action = StreamAction.all,
    final List<Filter> filters = const [],
    final int page = 0,
    final int limit = 20,
    final bool showDrafts = false,
  }) {
    late final StreamController<List<dynamic>> streamController;
    streamController = StreamController<List<dynamic>>.broadcast(
      onCancel: () {
        if (!streamController.hasListener) {
          streamController.close();
        }
      },
    );
    TetaCMS.instance.analytics.insertEvent(
      TetaAnalyticsType.streamCollection,
      'Teta CMS: realtime request',
      <String, dynamic>{},
      isUserIdPreferableIfExists: true,
    );
    TetaCMS.instance.client
        .getCollectionByName(
      collectionName,
      filters: filters,
      limit: limit,
      page: page,
      showDrafts: showDrafts,
    )
        .then(
      (final e) {
        TetaCMS.printWarning('${e.error}, ${e.data}');
        if (e.error == null) {
          streamController.add(e.data!);
        }
      },
    );
    on(
      collectionId: collectionName,
      callback: (final e) async {
        try {
          unawaited(
            TetaCMS.instance.analytics.insertEvent(
              TetaAnalyticsType.streamCollection,
              'Teta CMS: realtime request',
              <String, dynamic>{},
              isUserIdPreferableIfExists: true,
            ),
          );
        } catch (_) {}
        final resp = await TetaCMS.instance.client.getCollectionByName(
          collectionName,
          filters: filters,
          limit: limit,
          page: page,
          showDrafts: showDrafts,
        );
        if (resp.error == null) {
          streamController.add(resp.data!);
        }
      },
    );
    return streamController;
  }
}
