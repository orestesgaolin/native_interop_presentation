import 'dart:async';

import 'src/foreground_service_interop_plugin.g.dart';

export 'src/foreground_service_interop_plugin.g.dart';

final Expando<ForegroundServiceReplyStream> _replyStreams = Expando();

class ForegroundServiceReplyStream {
  ForegroundServiceReplyStream(this._service);

  final ExampleForegroundService _service;

  late final StreamController<String> _replies =
      StreamController<String>.broadcast(
        onListen: _onRepliesListen,
        onCancel: _onRepliesCancel,
      );

  ReplyListenerProxy$OnReplyListener? _listener;
  bool _hasRepliesSubscribers = false;

  Stream<String> get replies => _replies.stream;

  void _onRepliesListen() {
    _hasRepliesSubscribers = true;
    _attachListener();
  }

  void _onRepliesCancel() {
    _hasRepliesSubscribers = false;
    _detachIfNoSubscribers();
  }

  void _attachListener() {
    if (_listener != null) {
      return;
    }

    final impl = $ReplyListenerProxy$OnReplyListener(
      onReply: (string) {
        _replies.add(string.toDartString());
      },

      onReply$async: true,
    );

    _listener = ReplyListenerProxy$OnReplyListener.implement(impl);
    _service.setOnReplyListener(_listener!);
  }

  void _detachIfNoSubscribers() {
    if (_hasRepliesSubscribers) {
      return;
    }
    if (_listener == null) {
      return;
    }

    final noop = ReplyListenerProxy$OnReplyListener.implement(
      $ReplyListenerProxy$OnReplyListener(onReply: (_) {}),
    );
    _service.setOnReplyListener(noop);
    _listener = null;
  }
}

extension ForegroundServicePluginReplyStreams on ExampleForegroundService {
  ForegroundServiceReplyStream get replyStream =>
      _replyStreams[this] ??= ForegroundServiceReplyStream(this);
}
