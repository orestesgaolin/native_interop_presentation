import 'dart:async';

import 'package:jni/jni.dart' as jni;

import 'src/foreground_service_interop_plugin.g.dart';

export 'src/foreground_service_interop_plugin.g.dart'
    show
        ForegroundServicePlugin,
        ReplyListenerProxy,
        ReplyListenerProxy$OnReplyListener,
        ServiceConnection,
        $ReplyListenerProxy$OnReplyListener;

final Expando<ForegroundServiceReplyStream> _replyStreams = Expando();

class ForegroundServiceReplyStream {
  ForegroundServiceReplyStream(this._plugin);

  final ForegroundServicePlugin _plugin;
  late final StreamController<String> _messages =
      StreamController<String>.broadcast();
  late final StreamController<String> _replies =
      StreamController<String>.broadcast(
        onListen: _onRepliesListen,
        onCancel: _onRepliesCancel,
      );
  late final StreamController<void> _disconnected =
      StreamController<void>.broadcast(
        onListen: _onDisconnectedListen,
        onCancel: _onDisconnectedCancel,
      );

  ReplyListenerProxy$OnReplyListener? _listener;
  bool _hasRepliesSubscribers = false;
  bool _hasDisconnectedSubscribers = false;

  Stream<String> get messages => _messages.stream;

  Stream<String> get replies => _replies.stream;

  Stream<void> get disconnected => _disconnected.stream;

  void sendMessage(String message) {
    _plugin.sendMessage(message.toJString());
    _messages.add(message);
  }

  void _onRepliesListen() {
    _hasRepliesSubscribers = true;
    _attachListener();
  }

  void _onRepliesCancel() {
    _hasRepliesSubscribers = false;
    _detachIfNoSubscribers();
  }

  void _onDisconnectedListen() {
    _hasDisconnectedSubscribers = true;
    _attachListener();
  }

  void _onDisconnectedCancel() {
    _hasDisconnectedSubscribers = false;
    _detachIfNoSubscribers();
  }

  void _attachListener() {
    if (_listener != null) {
      return;
    }

    final impl = $ReplyListenerProxy$OnReplyListener(
      onDisconnected: () {
        _disconnected.add(null);
      },
      onReply: (string) {
        _replies.add(string.toDartString());
      },
      onDisconnected$async: true,
      onReply$async: true,
    );

    _listener = ReplyListenerProxy$OnReplyListener.implement(impl);
    _plugin.setOnReplyListener(_listener!);
  }

  void _detachIfNoSubscribers() {
    if (_hasRepliesSubscribers || _hasDisconnectedSubscribers) {
      return;
    }
    if (_listener == null) {
      return;
    }

    final noop = ReplyListenerProxy$OnReplyListener.implement(
      $ReplyListenerProxy$OnReplyListener(
        onReply: (_) {},
        onDisconnected: () {},
      ),
    );
    _plugin.setOnReplyListener(noop);
    _listener = null;
  }
}

extension ForegroundServicePluginReplyStreams on ForegroundServicePlugin {
  ForegroundServiceReplyStream get replyStream =>
      _replyStreams[this] ??= ForegroundServiceReplyStream(this);
}
