scope = logics.priceBook
numericOption = {autoGroup: true, groupSeparator:",", radixPoint: ".", suffix: " VNĐ", integerDigits:11, rightAlign: false}
Wings.defineHyper 'priceBookDefaultDetailRowEdit',
  rendered: ->
    @ui.$editSaleQuantity.inputmask "numeric", numericOption
    @ui.$editSaleQuantity.val Template.currentData().salePrice

    @ui.$editSaleDebtQuantity.inputmask "numeric", numericOption
    @ui.$editSaleDebtQuantity.val Template.currentData().saleDebtPrice

    @ui.$editImportQuantity.inputmask "numeric", numericOption
    @ui.$editImportQuantity.val Template.currentData().importPrice

    @ui.$editSaleQuantity.select()

  events:
    "keyup": (event, template) ->
      product = Template.currentData()

      salePrice = Math.abs(Helpers.Number(template.ui.$editSaleQuantity.inputmask('unmaskedvalue')))
      salePrice = undefined if salePrice is product.salePrice
      saleDebtPrice = Math.abs(Helpers.Number(template.ui.$editSaleDebtQuantity.inputmask('unmaskedvalue')))
      saleDebtPrice = undefined if saleDebtPrice is product.saleDebtPrice
      importPrice = Math.abs(Helpers.Number(template.ui.$editImportQuantity.inputmask('unmaskedvalue')))
      importPrice = undefined if importPrice is product.importPrice

      if event.which is 13
        if salePrice isnt undefined or importPrice isnt undefined or saleDebtPrice isnt undefined
          Template.parentData().updatePriceOfProduct(product._id, salePrice, importPrice, saleDebtPrice)
        Session.set("editingId")