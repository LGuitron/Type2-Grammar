import java.util.HashSet;

public class Main 
{
    public static void main(String args[]) 
    {
        HashSet<String> nonTerminalSymbols = new HashSet<String>();
        HashSet<String> productionRules    = new HashSet<String>();
        String initialSymbol;

        nonTerminalSymbols.add("S");
        nonTerminalSymbols.add("C");
        nonTerminalSymbols.add("D");
        
        productionRules.add("S->CD");
        productionRules.add("C->0C");
        productionRules.add("C->0");
        productionRules.add("D->1D");
        productionRules.add("D->1");
        
        initialSymbol = "S";     

        Grammar grammar = new Grammar(nonTerminalSymbols, productionRules, initialSymbol);
        System.out.println(grammar.testChain("001"));
        System.out.println(grammar.testChain("01"));
        System.out.println(grammar.testChain("011111111111"));
        System.out.println(grammar.testChain("000111"));
        
        System.out.println(grammar.testChain(""));
        System.out.println(grammar.testChain("00101"));
        System.out.println(grammar.testChain("010111"));
    }
}
