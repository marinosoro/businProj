$(document).ready(function() {
    // Toggle views with sidebar
    let navItems = $(".sidebar_item");
    navItems.click(function() {
        let oldSection = $(".sidebar_item.active").attr("id").substr(5);
        $(".sidebar_item.active").removeClass("active");
        $(this).addClass("active");
        let newSection = $(this).attr("id").substr(5);
        $("#content_" + oldSection).addClass("hidden");
        // $("#content_" + oldSection).hide();
        $("#content_" + newSection).toggleClass("hidden");
        // $("#content_" + newSection).show();
    })

    // Hide pages on startup
    // let sections = $(".section_content");
    // sections.hide();
    // $("#content_home").show();
})
