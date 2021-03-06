@ProviderSearch = new SearchSource 'providers', ['name'],
#  keepHistory: 1000 * 60 * 5
  localSearch: true

@ProviderSearch.fetchData =(searchText, options, callback) ->
  selector = {merchant: merchantId ? Merchant.getId()}; options = {sort: {name: 1}, limit: 20}
  if(searchText)
    regExp = Helpers.BuildRegExp(searchText);
    selector = {$or: [
      {name: regExp, merchant: merchantId ? Merchant.getId()}
    ]}
  callback(false, Schema.providers.find(selector, options).fetch())

Template.registerHelper 'providerSearches', ->
  ProviderSearch.getData
#    transform : (matchText, regExp) -> matchText.replace(regExp, "<b>$&</b>")
    sort      : {name: 1}
