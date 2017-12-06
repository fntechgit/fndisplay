$(document).ready(function () {
    summit();
});

function summit() {

    var height = $(".inner").height();

    var outerHeight = $(".scroll-wrapper-inner").height();

    if (height > outerHeight) {
        $(".inner").animate({ top: "-" + height }, 50000, "linear", slideBottom);
    }

}

function slideBottom() {

    var height = $(".inner").height();

    $(".inner").css("top", "1300px");

    $(".inner").animate({ top: "-" + height }, 50000, "linear", cycle);
}

function cycle() {
    slideBottom();
}