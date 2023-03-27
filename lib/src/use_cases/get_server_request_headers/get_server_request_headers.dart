import 'package:teta_cms/src/data_stores/local/server_request_metadata_store.dart';

/// Teta Store Headers
class GetServerRequestHeaders {
  /// Teta Store Headers
  GetServerRequestHeaders(this._metadataStore);

  /// Metadata of the store
  final ServerRequestMetadataStore _metadataStore;

  /// Returns the json
  Map<String, String> execute() {
    final metadata = _metadataStore.getMetadata();

    return <String, String>{
      'authorization': 'Bearer ${metadata.token}',
      'x-teta-prj-id': metadata.prjId.toString(),
      'content-type': 'application/json'
    };
  }
}
