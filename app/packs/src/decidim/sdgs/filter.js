const border_style_selected= "3px solid #555"
const border_style_unselected= "3px"

function toggleSdgFilterCellSelect(cell, selected) {
  if(selected) {
    cell.css("border", border_style_selected);
  } else {
    cell.css("border", border_style_unselected);
  }
}

$( document ).ready(function() {
  /**
    * Setup Sdgs selector
    */
  $('div.sdgs-filter input[type=hidden]').each(function () {
    const input= $(this);
    const current_value= input.val()

    // initial activation
    if (current_value != "" && (typeof current_value == "string")) {
      const cell= $('#sdgs-modal .sdg-cell[data-value=' + current_value + ']')
      toggleSdgFilterCellSelect(cell, true)
    }
  })

  /**
    * Configure click event
    */
  $('#sdgs-modal .sdg-cell').each(function (idx) {
    const cell= $(this)
    const current_value= cell.attr("data-value")

    cell.click(function () {
      let selected= false

      // toggle inputs
      const inputs= $('div.sdgs-filter input[type=hidden][data-value=' + current_value + ']')
      inputs.each(function () {
        const input= $(this)
        if(input.val() == "") {
          input.val(current_value)
          selected= true
        } else {
          input.val("")
        }
      })

      // update cell
      toggleSdgFilterCellSelect(cell, selected)
    });
  });

  /**
    * Send the filter form when done
    */
  let sdgs_opener= null;
  $('.sdgs-filter').click(function() {
    sdgs_opener= $(this)
  });
  $('#sdgs-modal .reveal__footer a.button').click(function() {
    sdgs_opener.parent("form").submit()
    sdgs_opener= null
  });
})
