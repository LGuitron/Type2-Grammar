import java.util.HashSet;
import java.util.ArrayList;

public class Grammar 
{
    private HashSet<String> nonTerminalSymbols;
    private HashSet<String> productionRules;
    private String startSymbol;
    
    public Grammar()
    {
      this.productionRules = new HashSet<String>();
    }
    
    public Grammar(HashSet<String> nonTerminalSymbols, HashSet<String> productionRules, String startSymbol)
    {
        this.nonTerminalSymbols = nonTerminalSymbols;
        this.productionRules    = productionRules;
        this.startSymbol        = startSymbol;
    }
    
    // Function for setting up non terminal symbols from GUI
    public void setNonTerminalSymbols(String symbolsString)
    {
        String[] symbolsArr = symbolsString.split(","); 
        this.nonTerminalSymbols = new HashSet<String>();
        
        for (String symbol : symbolsArr)
        {  
            this.nonTerminalSymbols.add(symbol);
        }
    }
    
    // Function for setting up starting symbol from GUI
    public void setStartSymbol(String startSymbol)
    {
        this.startSymbol = startSymbol;
    }
    
    // Function for adding a production rule from GUI
    public void addProductionRule(String productionRule)
    {
      this.productionRules.add(productionRule);
    }
    
    // Get number of production rules
    public int getRuleAmount()
    {
      return this.productionRules.size();
    }
    
    public DerivationTree testChain(String chain)
    {
        // List containing (chain, index, ruleApplied)
        ArrayList<ProductionStep> productionHistory = new ArrayList<ProductionStep>();
        return testRecursive(this.startSymbol, chain, productionHistory);
    }
    
    //private boolean testRecursive(String currentChain, String chain, String ruleHistory)
    //private boolean testRecursive(String currentChain, String chain, ArrayList<ProductionStep> productionHistory)
    private DerivationTree testRecursive(String currentChain, String chain, ArrayList<ProductionStep> productionHistory)
    {
        //System.out.println(currentChain);
        if(currentChain.equals(chain))
        {
            System.out.println(productionHistory);
            //return true;
            return new DerivationTree(true, productionHistory);
        }
        
        for (String rule : this.productionRules)
        {
            String[] ruleSymbols  = rule.split("->");
            String ntSymbol       = ruleSymbols[0];
            String genChain       = ruleSymbols[1];
            if(genChain.equals("null"))
                    genChain = "";
            
            // Iterate through the String and apply all possible susbsitutions for the current rule
            for (int i=0; i < currentChain.length(); i++)
            {
                if(Character.toString(currentChain.charAt(i)).equals(ntSymbol))
                {
                    String nextChain = currentChain.substring(0, i) + genChain + currentChain.substring(i+1);
                    
                    if(removeNonTerminals(nextChain).length() <= chain.length())
                    {
                        ArrayList<ProductionStep> newProductionHistory = new ArrayList<ProductionStep>();
                        for (ProductionStep step : productionHistory)
                        {
                          newProductionHistory.add(step);
                        }
                        newProductionHistory.add(new ProductionStep(currentChain.toString(), i, rule));
                        //boolean foundMatch = testRecursive(nextChain, chain, newProductionHistory);
                        //if(foundMatch)
                        //    return true;
                        DerivationTree derivationTree = testRecursive(nextChain, chain, newProductionHistory);
                        if(derivationTree.derivedSuccessful)
                          return derivationTree;
                    }
                }
            }
        }
        return new DerivationTree(false, new ArrayList<ProductionStep>());
    }    
    
    // Helper function that removes nonTerminal symbols from a chain
    private String removeNonTerminals(String chain)
    {
        String returnString = chain;
        for (String symbol : this.nonTerminalSymbols)
        {
            returnString = returnString.replace(symbol, "");
        }
        return returnString;
    }
}
