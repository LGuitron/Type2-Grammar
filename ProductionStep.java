public class ProductionStep
{
  public String originalChain;
  public int modifiedIndex;    // Index of the nonTerminal index that was substituted in the chain
  public String ruleApplied; 
  public ProductionStep(String originalChain, int modifiedIndex, String ruleApplied)
  {
    this.originalChain = originalChain;
    this.modifiedIndex = modifiedIndex;
    this.ruleApplied   = ruleApplied;
  }
  
  @Override
  public String toString()
  {
    return "chain: " + this.originalChain + " index: " + this.modifiedIndex + " rule: " + this.ruleApplied;
  }
}
