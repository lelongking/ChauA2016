Wings.defineHyper 'createLoanTransaction',
  created: ->
  rendered: ->
    self = this
    integerOption  = {autoGroup: true, groupSeparator:",", radixPoint: ".", suffix: " VNĐ", integerDigits: 12}
    $transactionAmount = self.ui.$transactionAmount
    $transactionAmount.inputmask "integer", integerOption
    $transactionAmount.val 0

    decimalOption        = {autoGroup: true, groupSeparator:",", radixPoint: ".", suffix: " %/tháng", integerDigits:4}
    $transactionInterestRate = self.ui.$transactionInterestRate
    $transactionInterestRate.inputmask "decimal", decimalOption
    $transactionInterestRate.val Session.get('merchant')?.interestRates?.loan ? 0


  helpers:
    currentOwner: -> Session.get('transactionOwner')

  events:
    "keyup .transaction-field":  (event, template) ->
      if transactionDetail = Session.get('transactionDetail')
        if event.target.name is 'transactionAmount'
          transactionDetail.amount = parseInt(template.ui.$transactionAmount.inputmask('unmaskedvalue'))

        else if event.target.name is 'transactionInterestRate'
          transactionDetail.interestRate = parseFloat(template.ui.$transactionInterestRate.inputmask('unmaskedvalue'))
          Session.set('transactionDetail', transactionDetail)

        else if event.target.name is 'transactionDescription'
          transactionDetail.description = template.ui.$transactionDescription.val()
          Session.set('transactionDetail', transactionDetail)

        Session.set('transactionDetail', transactionDetail)