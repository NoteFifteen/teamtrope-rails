// assets/javascripts/manuscripts.js

/**
 * This file contains javascript relating to some if not all of the Manuscript related forms
 */

function submitProofreadManuscriptForm()
{
    var form = $("#submit_proofread");
    if(form.valid) {
        form.submit();
    }
}
