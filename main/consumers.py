# -*- coding: utf-8 -*-
from channels import Group
from channels.auth import channel_session_user, channel_session_user_from_http


# Connected to websocket.connect
@channel_session_user_from_http
def ws_add(message):
    # Accept connection
    message.reply_channel.send({"accept": True})
    # Add them to the right group
    Group(message.user.username).add(message.reply_channel)


# Connected to websocket.receive
@channel_session_user
def ws_message(message):
    Group(message.user.username).send({
        "text": message['text'],
    })


# Connected to websocket.disconnect
@channel_session_user
def ws_disconnect(message):
    Group(message.user.username).discard(message.reply_channel)
