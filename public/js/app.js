$(function() {
    var dialog = document.querySelector('dialog');
    if (! dialog.showModal) {
        dialogPolyfill.registerDialog(dialog);
    }
    dialog.querySelector('.close').addEventListener('click', function() {
        dialog.close();
    });
    
    // set origin twitter node
    $("#twitter-origin-form").on('submit',function(e) {
        var screen_name = $('#twitter-screen-name').val();
        $.get('/graph', {screen_name: screen_name}, "json")
         .done(function(data) {
             console.log(data);
             $('#graph-json-fld')[0].parentElement.MaterialTextfield.change(JSON.stringify(data));
         })
         .fail(function() {
             document.querySelector('dialog').showModal();
         });
        $('#msg').focus();
        e.preventDefault();
    });
});
