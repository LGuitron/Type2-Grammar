import java.util.HashSet;

public class Main 
{
    public static void main(String args[]) 
    {
        HashSet<String> nonTerminalSymbols = new HashSet<String>();
        HashSet<String> productionRules    = new HashSet<String>();
        String initialSymbol;

        nonTerminalSymbols.add("S");
        nonTerminalSymbols.add("P");
        
        productionRules.add("S->PP");
        productionRules.add("P->null");
        productionRules.add("P->aPb");
        productionRules.add("P->Pb");
        
        initialSymbol = "S";     

        Grammar grammar = new Grammar(nonTerminalSymbols, productionRules, initialSymbol);
        //System.out.println(grammar.testChain(""));
        //System.out.println(grammar.testChain("abab"));
        System.out.println(grammar.testChain("abbaaabbb"));
        //System.out.println(grammar.testChain("b"));
        //System.out.println(grammar.testChain("bb"));
        
        //System.out.println(grammar.testChain("aababb"));
        //System.out.println(grammar.testChain("aabba"));
        //System.out.println(grammar.testChain("aba"));
    }
}
