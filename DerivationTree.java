import java.util.ArrayList;

// Class that encapsulates success for finding derivation tree together with arraylist of production steps
public class DerivationTree
{
  public boolean derivedSuccessful;
  public ArrayList<ProductionStep> productionSteps;
  
  public DerivationTree(boolean derivedSuccessful, ArrayList<ProductionStep> productionSteps)
  {
    this.derivedSuccessful = derivedSuccessful;
    this.productionSteps   = productionSteps;
  }
}
