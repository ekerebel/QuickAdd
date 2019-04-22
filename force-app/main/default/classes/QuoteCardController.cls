public with sharing class QuoteCardController{
@AuraEnabled
    public static void addProducts(String quoteId, String productCodes){
        System.debug('====testAddProducts.addProducts======>'+quoteId+'<==='+productCodes);
        QuoteReader qReader = new QuoteReader();
        QuoteModel quoteModel = qReader.read(quoteId);
        List<String> ProductCodeList = productCodes.split(',');
        
        List<Product2> ProductsList = [SELECT Id, ProductCode, Name FROM Product2 WHERE ProductCode IN :ProductCodeList];
        System.debug('Products:'+ProductsList.size());

        Map<String, Id> MapProductId = new Map<String, Id>();
        //m1.put(1, 'First item');
        
        for (Product2 myProduct : ProductsList){
            MapProductId.put(myProduct.ProductCode,myProduct.Id);
        }

        ProductReader pReader = new ProductReader();
        List<ProductModel> productModels = new List<ProductModel>();
        for(String myProductCode : ProductCodeList){
            ProductModel productModel = pReader.read(MapProductId.get(myProductCode),'01s2E000001PZ8wQAG','USD');
            productModels.add(productModel);
            System.debug(productModel);
        }

        
        
    
        System.debug('Lines ==> '+quoteModel.lineItems.size());
     
        ProductAdder adder = new ProductAdder();
        QuoteModel quoteWithProducts = adder.add(quoteModel, productModels, 0);
        System.debug(JSON.serialize(quoteWithProducts)); 
        
        System.debug('Lines ==> '+quoteWithProducts.lineItems.size());
        
        
        QuoteCalculator calculator = new QuoteCalculator();
        QuoteModel calculatedQuote = calculator.calculate(quoteWithProducts, null);
        System.debug(JSON.serialize(calculatedQuote));
        
        QuoteSaver saver = new QuoteSaver();
        QuoteModel savedQuote = saver.save(calculatedQuote);
        System.debug(JSON.serialize(savedQuote));  

        
          
    }
    
    
}
