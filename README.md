OVBridgeKit
===========

An Event-based Objective-C framework which make Objective-C recieve messages from Javascript without configuring any Javascript code.

When a UIWebView load a webview, if you want to add some simple callback logic in the web page, all you have to do is to know the ID of the relative message sender in html dom and register a event listener without considering the code in HTML/CSS/Javascript.

The mechanism is based on Event Lister. At first you have to register a control, like button, for a custom event type. Then when a user activate the control, like click the button, there will be a event triggered and the relative delegate function will be call.

For example, if you register a event type with eventId 1000 to a button by calling: 

// register the sender for the event with eventId
// param: eventId     ---------- ID of the event
// param: eventLabel  ---------- Some description for the Event
// param: senderId    ---------- The dom Id of the control for register
- (void)registerEvent:(NSInteger)eventId label:(NSString *)eventLabel sender:(NSString *)senderId;

Then when the button is clicked, a event with eventId 1000 will be sent to native and invoke the function: 

// callback function for handling the triggered event
// param: webView     ---------- The web view just to load the web page
// param: event       ---------- The come-back event being caught
- (void)webView:(OVBridgeWebView *)webView didRecieveEvent:(OVBridgeEvent *)event;

where you can implement the callback logic...

Illustration above just clarify the rough process of the event-listener mechanism. There are some more important function being statemented in the protocol OVBridgeWebViewDelegate...

Anyway, let's start with demo...
