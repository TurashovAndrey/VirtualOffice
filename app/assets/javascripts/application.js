//= require jquery
//= require jquery_ujs
//= require jquery.purr
//= require_tree .
//= require best_in_place

 jQuery(function() {
    jQuery("#new_ev").dialog({
        autoOpen: true,
        show: "slide",
        hide: "slide",
        title: "Событие",
        width: 400
    });
});

jQuery(function() {
        jQuery("#opener").click(function() {
			jQuery("#new_ev").dialog("open");
			return false;
		});
});

jQuery(function() {
    jQuery("#dialog").dialog({
        title: "Вход"
    });
});

jQuery(function() {
    jQuery("table#users_table td").click(function() {
	    jQuery("#worker").dialog("open");
			return false;
		});
});

jQuery(function() {
    jQuery("#event_start_at").datetimepicker();
});

jQuery(function() {
    jQuery("#event_end_at").datetimepicker();
});

jQuery(function() {
    jQuery("#task_due").datetimepicker();
});

// Add message to chat
function addMessage(type, header, content) {
  $("<li class='" + type + "'><span>" + header + "</span>" + content + "</li>").appendTo("#messages");
  $("#messages").prop('scrollTop', $("#messages").prop("scrollHeight"));
};

function runChat(username,channel) {
  // Connect to Socky Server
  var socky = new Socky.Client('ws://localhost:3001/websocket/my_app');
  
  // Bind message after connecting to server
  socky.bind("socky:connection:established", function() {
    addMessage("system", '', "Connected - joining channel...");
  });
  
  // Bind message after disconnecting from server
  socky.bind("socky:connection:closed", function() {
    addMessage("system", '', "Connection closed");
  });

  // Subscribe to channel
  // You can subscribe to as much channels as you want
  // { write:true } option will allow sending messages directly to server
  //   note: this will require enabling this in authenticator
  // { data: { login: username } } all 'data' options are passed to other users
     //var channel = socky.subscribe("presence-chat-channel", { write: true, data: { login: username } });
       var channel = socky.subscribe("presence-chat-"+channel, { write: true, data: { login: username } });

  // Bind message after successfull joining channel
  channel.bind("socky:subscribe:success", function(members) {
    for (i=0; i<members.length; i++)
    {
    }
    addMessage("system", '', "Joined channel - " + members.length + " users online.");
  });

  // Bind message after other user joins channel
  channel.bind("socky:member:added", function(data) {
    addMessage("login", "", data.login + " joined chat");
  });

  // Bind message after other user disconnect from channel
  channel.bind("socky:member:removed", function(data) {
    addMessage("logout", "", data.login + " left chat");
  });

  // Bind function to 'chat_message' event
  // This event can be sent by all clients with 'write' permission
  channel.bind("chat_message", function(message) {
    addMessage('', message.login + ': ', message.content);
  });

  // jQuery bind sending message via form to channel event
  $("#message_form").submit(function(e) {
    e.preventDefault();
    var currentDate = new Date();
    channel.trigger("chat_message", { content: "["+currentDate.toLocaleString()+']:'+$("#message").val(), login: username });
    $('#message').val('')
    return false;
  });
};

// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

	var videos = 1;

	var publisher;
	var publisherObj;

	var subscribers = {};
	var subscriberObj = {};

	var MAX_WIDTH_VIDEO = 264;
	var MAX_HEIGHT_VIDEO = 198;

	var MIN_WIDTH_VIDEO = 200;
	var MIN_HEIGHT_VIDEO = 150;

	var MAX_WIDTH_BOX = 800;
	var MAX_HEIGHT_BOX = 600;

	var CURRENT_WIDTH = MAX_WIDTH_VIDEO;
	var CURRENT_HEIGHT = MAX_HEIGHT_VIDEO;

	function sessionConnectedHandler(event) {
		publish();

		for (var i = 0; i < event.streams.length; i++) {
			addStream(event.streams[i]);
		}
	}

	function streamCreatedHandler(event) {
		for (var i = 0; i < event.streams.length; i++) {
			addStream(event.streams[i]);
		}
	}

	function streamDestroyedHandler(event) {
		videos--;

		layoutManager();
	}


	function exceptionHandler(event) {
    	alert("Exception msg:" + event.message + "title: " + event.title + " code: " + event.code);
	}

	//--------------------------------------
	//  HELPER METHODS
	//--------------------------------------
	function addStream(stream) {
		// Check if this is the stream that I am publishing. If not
		// we choose to subscribe to the stream.
		if (stream.connection.connectionId == session.connection.connectionId) {
			return;
		}

		var div = document.createElement('div');	// Create a replacement div for the subscriber
		var divId = stream.streamId;	// Give the replacement div the id of the stream as its id
		div.setAttribute('id', divId);
		document.getElementById("videobox").appendChild(div);
		subscriberObj[stream.streamId] = div; 
		subscribers[stream.streamId] = session.subscribe(stream, divId, {"width": CURRENT_WIDTH, "height": CURRENT_HEIGHT});

		videos++;
		layoutManager();
	}

	function publish() {
		if (!publisher) {
			var parentDiv = document.getElementById("videobox");
			publisherObj = document.createElement('div');			// Create a replacement div for the publisher
			publisherObj.setAttribute('id', 'opentok_publisher');
			parentDiv.appendChild(publisherObj);
			publisher = session.publish('opentok_publisher', {"width": CURRENT_WIDTH, "height": CURRENT_HEIGHT});
		}
	}

	function layoutManager() {
		var estBoxWidth = MAX_WIDTH_BOX / videos;
		var width = Math.min(MAX_WIDTH_VIDEO, Math.max(MIN_WIDTH_VIDEO, estBoxWidth));
		var height = 3*width/4;

		publisherObj.height = height;
		publisherObj.width = width;

		for(var subscriberDiv in subscriberObj) {
			subscriberDiv.height = height;
			subscriberDiv.width = width;
		}

		CURRENT_HEIGHT = height;

		CURRENT_WIDTH = width;
	}

$("#customer-form").dialog({
    autoOpen: true,
    height: 'auto',
    width: 'auto',
    modal: true,
    closeOnEscape: true,
    title: 'New Customer'
    });