var last_username;
var last_tweet;
var last_fullname;

var useold = false;

function slideRight() {

    tweet();

    $("#twitter_block").css("left", "1580px");

    setTimeout(enterRight, 1000);
}

function enterRight() {
    $("#twitter_block").animate({ left: "40px" }, 500, "swing");
}

function twitter() {
    $("#twitter_block").animate({ left: "-1080" }, 500, "swing", slideRight);
}

function enterRight() {
    $("#twitter_block").animate({ left: "40px" }, 500, "swing");
}

function tweet() {
    $.ajax({
        type: "POST",
        url: "/display.asmx/random",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data, status) {

            $("#twitter-pic").attr('src', data.d.profilepic);

            if (useold === true) {
                // set twitter full name
                if ($("#twitter_name").length) {
                    $("#twittername").text(data.d.full_name);
                }

                // set twitter username
                if ($("#twitter_username").length) {
                    $("#twitterusername").text('@' + data.d.username);
                }

                // set tweet
                if ($("#twitter_tweet").length) {
                    $("#twitterdesc").text(data.d.description);
                }
            } else {

                // set twitter full name
                if ($("#twitter_name").length) {
                    $("#twitter_name .fr-editor").html($("#twitter_name .fr-editor").html().replace(/{.+}/, '<span id="twittername">' + data.d.full_name) + '</span>');
                }

                // set twitter username
                if ($("#twitter_username").length) {
                    $("#twitter_username .fr-editor").html($("#twitter_username .fr-editor").html().replace(/{.+}/, '<span id="twitterusername">@' + data.d.username + '</span>'));
                }

                // set tweet
                if ($("#twitter_tweet").length) {
                    $("#twitter_tweet .fr-editor").html($("#twitter_tweet .fr-editor").html().replace(/{.+}/, '<span id="twitterdesc">' + data.d.description + '</span>'));
                }
            }

            useold = true;

            last_username = data.d.username;
            last_fullname = data.d.full_name;
            last_tweet = data.d.description;

            //if (data.d.source != null) {

            //    console.log(data.d.source);

            //    $("#twitimg").html('<img src="' + data.d.source + '" />');
            //} else {
            //    $("#twitimg").text('');
            //}
        }
    });
}