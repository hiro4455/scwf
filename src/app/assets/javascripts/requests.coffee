# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.showMsg = (msg) ->
  alert(msg)
  false

window.addToAuthor = (autherListId, autherListValuesId)->
  
  candidates = to_array(document.getElementById("candidates").selectedOptions)
  authors = document.getElementById(autherListId)

  # remove duplicate entry
  to_array(authors).forEach (author) ->
    toBeRemove = candidates.findIndex((x) -> x.value == author.value)
    if toBeRemove != -1
      candidates.splice(toBeRemove, 1)

  # add to authors list
  candidates.forEach (e) ->
    newElement = document.createElement("option")
    newElement.value = e.value
    newElement.label = e.label
    newElement.selected = true
    authors.appendChild(newElement)

  # rebuild authors value as CSV
  authorsList = document.getElementById(autherListValuesId)
  authorsListValues = authorsList.value.split(",").concat(candidates.map((x) -> x.value))
  if authorsListValues[0] == ""
    authorsListValues.shift()
  authorsList.value = authorsListValues.join(",")

window.removeFromAuthor = (autherListId, autherListValuesId) ->

  # remove from authors list
  authors = document.getElementById(autherListId)
  to_array(authors.selectedOptions).map((x) => x.index).reverse().forEach (toBeRemove) ->
    authors.remove(toBeRemove)

  # rebuild authors value as CSV
  authorsList = document.getElementById(autherListValuesId)
  authorsList.value = to_array(authors).map((x) => x.value).join(",")

window.updateFilter = (filterBox, target) ->
  #
  filterString = document.getElementById(filterBox).value
  console.log(filterString)
  to_array(document.getElementById(target).options).forEach (option) ->
    if option.innerText.indexOf(filterString) == -1
      option.setAttribute('hidden', 1)
    else
      option.removeAttribute('hidden')

window.clearFilter = (filterBox, target) ->
  filterString = document.getElementById(filterBox).value = ""
  window.updateFilter(filterBox, target)

to_array = (collection) -> 
  result = []
  for item in collection
    result.push(item)
  result
