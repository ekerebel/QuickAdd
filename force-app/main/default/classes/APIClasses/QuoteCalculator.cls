public with sharing class QuoteCalculator {     

  public QuoteModel calculate(QuoteModel quote, String callbackClass) {
    QuoteCalculatorContext ctx = new QuoteCalculatorContext(quote, callbackClass);
    System.debug('=====ctx=====');
    System.debug(JSON.serialize(ctx));
    //SBQQ.ServiceRouter.load('SBQQ.QuoteAPI.QuoteCalculator', null, JSON.serialize(ctx));   
    String quoteJSON = SBQQ.ServiceRouter.load('SBQQ.QuoteAPI.QuoteCalculator', null, JSON.serialize(ctx));
    return (QuoteModel) JSON.deserialize(quoteJSON, QuoteModel.class); 
  }    

  private class QuoteCalculatorContext {        
    private QuoteModel quote;
    private String callbackClass;        

    private QuoteCalculatorContext(QuoteModel quote, String callbackClass) {
      this.quote = quote;            
      this.callbackClass = callbackClass;        
    }
  } 
}
