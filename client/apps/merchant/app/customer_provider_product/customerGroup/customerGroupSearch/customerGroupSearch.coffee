Enums = Apps.Merchant.Enums
scope = logics.customerManagement

Wings.defineHyper 'customerGroupSearch',
  created: ->
    self = this
    self.searchFilter = new ReactiveVar('')


  helpers:
    activeClass: ->
      if @_id is Session.get('mySession')?.currentCustomerGroup then 'active' else ''

    listCustomerGroups: ->
      selector = {merchant : merchantId ? Merchant.getId()}; options  = {sort: {isBase: 1, nameSearch: 1}}
      searchText = Template.instance().searchFilter.get()

      if(searchText)
        regExp = Helpers.BuildRegExp(searchText);
        selector =
          $and: [
            merchant : Merchant.getId()
          ,
            $or: [{name: regExp} , {nameSearch: regExp}]
          ]


#      unless User.hasManagerRoles()
#        if searchText
#          selector.$or[0].customerLists = {$in: Session.get('myProfile').customers}
#        else
#          selector.customerLists = {$in: Session.get('myProfile').customers}
      Schema.customerGroups.find(selector, options).fetch()


  events:
    "click .caption.inner.toCustomer": (event, template) ->
      FlowRouter.go('customer')

    "click .create-new-command": (event, template) ->
      FlowRouter.go('createCustomerGroup')

    "click .list .doc-item": (event, template) ->
      CustomerGroup.setSessionCustomerGroup(@_id)

    "keyup input[name='searchFilter']": (event, template) ->
      customerGroupSearchByInput(event, template)



customerGroupSearchByInput = (event, template) ->
  searchFilter      = Template.instance().searchFilter
  $searchFilter     = template.ui.$searchFilter
  searchFilterText  = $searchFilter.val().replace(/^\s*/, "").replace(/\s*$/, "")

  Helpers.deferredAction ->
    if searchFilter.get() isnt searchFilterText
      searchFilter.set(searchFilterText)
  , "customerGroupSearch"
  , 50

