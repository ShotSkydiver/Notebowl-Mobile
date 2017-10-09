
var hookStatus = function() {

    window.webkit.messageHandlers.debugMessage.postMessage("hooking scope!");
    // checkDebugStatus();
};

var denisonLogin = function() {
    document.querySelector('#username').value = "check_y16";
    document.querySelector('#password').value = "(N0t3B0wL@2016)";
    document.querySelector('#loginForm').submit();
};

var emailVerify = function() {

    document.querySelector("#email").value = "bob.smith@notebowl.com";
    $('#email').triggerHandler('input');

    $('form').triggerHandler('submit');

    var passwordField = document.querySelector("#password");

    var checkExist = setInterval(function() {
         window.webkit.messageHandlers.debugMessage.postMessage("password field not found!");
		if ($(passwordField).length) {
			window.webkit.messageHandlers.debugMessage.postMessage("found password field!");
			// window.submitCreds();
			clearInterval(checkExist);
		}
     }, 300);
    checkExist;
};

var submitCreds = function() {
    document.querySelector("#password").value = "notebowlbeta";
    $('#password').triggerHandler('input');

    window.webkit.messageHandlers.debugMessage.postMessage("submitting user credentials!");

    $('form').triggerHandler('submit');
};

function checkDebugStatus() {
    var testScope = $('form').scope();
    if (testScope == null) {
        window.webkit.messageHandlers.debugMessage.postMessage("debug mode not enabled! enabling now!");
        angular.reloadWithDebugInfo();
    }
    else {
        window.webkit.messageHandlers.debugMessage.postMessage("debug mode already enabled! doing nothing!");
    }
};


window.webkit.messageHandlers.debugMessage.postMessage(window.name);
