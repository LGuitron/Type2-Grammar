import java.util.HashSet;

public class Grammar 
{
    private HashSet<String> nonTerminalSymbols;
    private HashSet<String> productionRules;
    private String startSymbol;
    
    public Grammar(HashSet<String> nonTerminalSymbols, HashSet<String> productionRules, String startSymbol)
    {
        this.nonTerminalSymbols = nonTerminalSymbols;
        this.productionRules    = productionRules;
        this.startSymbol        = startSymbol;
    }
    
    public boolean testChain(String chain)
    {
        return testRecursive(this.startSymbol, chain, "");
    }
    
    private boolean testRecursive(String currentChain, String chain, String ruleHistory)
    {
        //System.out.println(currentChain);
        if(currentChain.equals(chain))
        {
            System.out.println(ruleHistory);
            return true;
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
                        boolean foundMatch = testRecursive(nextChain, chain,ruleHistory + ", chain: " + currentChain.toString() + " index: " + i + " " + rule + "\n");
                        if(foundMatch)
                            return true;
                    }
                }
            }
        }
        return false;
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
