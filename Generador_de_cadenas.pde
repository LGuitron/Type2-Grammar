import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;

// Grammar Object
Grammar grammar;

// Button sizes
int buttonWidth;
int buttonHeight;

// Button colors
color buttonColor;
color buttonHighlight;

// Height of all buttons
int buttonY;

// Button X locations
int nonTerminalsButtonX;
int startSymbolButton;
int productionButtonX;
int chainButtonX;

// Button over booleans
boolean nonTerminalsOver = false;
boolean startSymbolOver  = false;
boolean productionOver   = false;
boolean chainOver        = false;

// TextBox Info
TextBox[] textBoxes;    //Text boxes for requiring diffent inputs to the user
color textColor;
final int stateNormal           = 0;
final int nonTerminalsState     = 1;
final int startSymbolState      = 2;
final int productionRulesState  = 3;
final int chainState            = 4;
int state = stateNormal;

// Grammar info
int infoX;
int infoY; 
int infoSpacing;
String nonTerminalSymbols;
String initialSymbol;
String productionRules;
String insertedChain;

// Boolean for displaying result and DerivationTree object
DerivationTree derivationTree;
boolean displayResult;

// Parameters for derivation tree visual representation
// Store position of nonTerminal nodes in lists
float startXpos;
float startYpos;

HashMap<Integer, Float> nodeXpositions;
HashMap<Integer, Float> nodeYpositions;
HashMap<Integer, Integer> nodeDepth;

int nodeSeparationX;
float xSeparationDecay;
int nodeSeparationY;

int nodeWidth;
int textOffsetX;
int textOffsetY;

void setup() {
  fullScreen();
  
  grammar = new Grammar();

  buttonWidth  = width/10;
  buttonHeight = height/15;
  
  buttonColor = color(0,128,0);
  buttonHighlight = color(0,192,0);
  
  buttonY = height/20;
  
  nonTerminalsButtonX = 2*width/6 + width/20;
  startSymbolButton   = 3*width/6 + width/20;
  productionButtonX   = 4*width/6 + width/20;
  chainButtonX        = 5*width/6 + width/20;
 
  textColor = color(255);
  textSize(16);
  
  rectMode(CORNER);
  textAlign(LEFT);
  
  textBoxes = new TextBox[4];
  instantiateBox(0, "Introduce los simbolos no terminales separados por comas:");
  instantiateBox(1, "Introduce el simbolo inicial:");
  instantiateBox(2, "Agrega una regla de produccion con el formato    S->aSb");
  instantiateBox(3, "Introduce la cadena a probar con la gramatica actual:");
  
  for (int i=0; i<4; i++){
    textBoxes[i].isFocused = true;
  }
  
  infoX = width/30;
  infoY = height/20;
  
  nonTerminalSymbols = "[]";
  initialSymbol      = "";
  productionRules    = "";
  insertedChain      = "";
  
  displayResult = false;

  startXpos = (float)width/2;
  startYpos =(float)height/3;  
  nodeSeparationX = width/3;
  nodeSeparationY = height/12;
  
  xSeparationDecay = 0.6;
  
  nodeWidth = 40;
  textOffsetX = 5;
  textOffsetY = 5;
  
}

void draw() {
  update(mouseX, mouseY);
  background(150);
  fill(0,128,128);
  rect(0,height/4,width,3*height/4);
  fill(0);
  textSize(48);
  textSize(16);

  setFillColor(nonTerminalsOver);
  rect(nonTerminalsButtonX, buttonY , buttonWidth, buttonHeight);
  setFillColor(startSymbolOver);
  rect(startSymbolButton, buttonY , buttonWidth, buttonHeight);
  setFillColor(productionOver);
  rect(productionButtonX, buttonY , buttonWidth, buttonHeight);
  setFillColor(chainOver);
  rect(chainButtonX, buttonY , buttonWidth, buttonHeight);
  
  fill(textColor);
  text("S. No terminales", nonTerminalsButtonX + buttonWidth/20 , buttonY + buttonHeight/1.6); 
  text("Simbolo Inicial", startSymbolButton + buttonWidth/20 , buttonY + buttonHeight/1.6); 
  text("R. de produccion", productionButtonX + buttonWidth/20 , buttonY + buttonHeight/1.6); 
  text("Prueba cadena", chainButtonX + buttonWidth/20 , buttonY + buttonHeight/1.6); 
  
  if(state > 0)
  {
    textBoxes[state-1].display();
  }
  
  fill(0);
  text("V : " + nonTerminalSymbols, infoX , infoY);
  text("S : " + initialSymbol, infoX , 2*infoY); 
  text("P : " + productionRules, infoX , 3*infoY); 
  text("Cadena : " + insertedChain, infoX , 4*infoY); 
  fill(255,165,0);
  
  // Draw derivation tree
  if(displayResult)
    drawDerivationTree();
}

void update(int x, int y) {
  if ( overRect(nonTerminalsButtonX, buttonY , buttonWidth, buttonHeight) ) {
    nonTerminalsOver = true;
  } else {
    nonTerminalsOver = false;
  }
  
   if ( overRect(startSymbolButton, buttonY , buttonWidth, buttonHeight) ) {
    startSymbolOver = true;
  } else {
    startSymbolOver = false;
  }
  
   if ( overRect(productionButtonX, buttonY , buttonWidth, buttonHeight) ) {
    productionOver = true;
  } else {
    productionOver = false;
  }
  
   if ( overRect(chainButtonX, buttonY , buttonWidth, buttonHeight) ) {
    chainOver = true;
  } else {
    chainOver = false;
  }
}

void mouseClicked() {
  if (nonTerminalsOver) {
     state = nonTerminalsState;
  }
  if(startSymbolOver){
    state = startSymbolState;
  }
   if(productionOver){
    textBoxes[productionRulesState-1].txt = "";
    state = productionRulesState;
  }
   if(chainOver){
    state = chainState;
  }
}

// Helper function to set fill color for each button
void setFillColor(boolean overButton)
{
  if(overButton){
    fill(buttonHighlight);
  }
  else{
    fill(buttonColor);
  }
}

boolean overRect(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

//====================================================
void keyTyped() {
  if (state==stateNormal) {
    // do nothing
  } else if (state > stateNormal) {
    //
    textBoxes[state-1].tKeyTyped();
  }
}//func 
 
void keyPressed() {
  if (state==stateNormal) {
    //
  } else if (state > stateNormal) {
    //
    textBoxes[state-1].tKeyPressed();
  }
}

// Text Boxes for user input
void instantiateBox(int index, String message) {
  
  //statesTbox = new TextBox(
  textBoxes[index] = new TextBox(
    message, 
    width/4, height/4 + height/16, // x, y
    width/2, height/2 - height/4 - height/8, // w, h
    215, // lim
    0300 << 030, color(235,184,82), // textC, baseC
    color(-1), color(-1)); // bordC, slctC
}



// ===================================================

class TextBox {
 
  // demands rectMode(CORNER)
 
  final color textC, baseC, bordC, slctC;
  final short x, y, w, h, xw, yh, lim;
 
  boolean isFocused;
  String txt = "";
  String title; 
 
  TextBox(
    String tt, 
    int xx, int yy, 
    int ww, int hh, 
    int li, 
    color te, color ba, color bo, color se) {
 
    title=tt;
 
    x = (short) xx;
    y = (short) yy;
    w = (short) ww;
    h = (short) hh;
 
    lim = (short) li;
 
    xw = (short) (xx + ww);
    yh = (short) (yy + hh);
 
    textC = te;
    baseC = ba;
    bordC = bo;
    slctC = se;
  }
 
  void display() {
    stroke(isFocused? slctC : bordC);
 
    // outer 
    fill(baseC);
    rect(x-10, y-90, w+20, h+100);
 
    fill(0); 
    text(title, x, y-90+20);
 
    // main / inner
    fill(baseC);
    rect(x, y, w, h);
 
 
    fill(textC);
    text(txt + blinkChar(), x, y, w, h);
  }
 
  void tKeyTyped() {
 
    char k = key;
 
    if (k == ESC) {
      // println("esc 2");
      state=stateNormal; 
      key=0;
      return;
    } 
 
    if (k == CODED)  return;
 
    final int len = txt.length();
 
    if (k == BACKSPACE)  txt = txt.substring(0, max(0, len-1));
    else if (len >= lim)  return;
    else if (k == ENTER || k == RETURN) {
      // this ends the entering 
      println("RET ");
      
      if(state == nonTerminalsState){
        grammar.setNonTerminalSymbols(txt);
        nonTerminalSymbols = "[" + txt + "]";
      }
      else if(state == startSymbolState){
        grammar.setStartSymbol(txt);
        initialSymbol = txt;
      }
      else if(state == productionRulesState){
        
        if(grammar.getRuleAmount()>0)
        {
           productionRules += ", ";
        }
        grammar.addProductionRule(txt);
        productionRules += txt;
      }

      else if(state == chainState){
        derivationTree = grammar.testChain(txt);
        insertedChain = txt;
        displayResult     = true;
      }
      
      state  = stateNormal; // close input box 
      
    } else if (k == TAB & len < lim-3)  txt += "    ";
    else if (k == DELETE)  txt = "";
    else if (k >= ' ')     txt += str(k);
  }
 
 
  void tKeyPressed() {
    if (key == ESC) {
      println("esc 3");
      state=stateNormal;
      key=0;
    }
 
    if (key != CODED)  return;
 
    final int k = keyCode;
 
    final int len = txt.length();
 
    if (k == LEFT)  txt = txt.substring(0, max(0, len-1));
    else if (k == RIGHT & len < lim-3)  txt += "    ";
  }
 
  String blinkChar() {
    return isFocused && (frameCount>>2 & 1) == 0 ? "_" : "";
  }
 
  boolean checkFocus() {
    return isFocused = mouseX > x & mouseX < xw & mouseY > y & mouseY < yh;
  }
}

void drawDerivationTree()
{ 
  if(derivationTree.derivedSuccessful)
  {
    nodeXpositions = new HashMap<Integer,Float>();
    nodeYpositions = new HashMap<Integer,Float>();
    nodeDepth      = new HashMap<Integer, Integer>();
    nodeXpositions.put(0, startXpos);
    nodeYpositions.put(0, startYpos);
    nodeDepth.put(0,0);
  
    for (ProductionStep step : derivationTree.productionSteps)
    {
        // Check number of descentants of this node
        String originalChain  = step.originalChain;
        String generatedChain = step.ruleApplied.split("->")[1];
        int modifiedIndex     = step.modifiedIndex;
        
        // Get X and Y positions of the current node and remove entry from arraylist
        float posX = nodeXpositions.remove(modifiedIndex);
        float posY = nodeYpositions.remove(modifiedIndex);
        int depth  = nodeDepth.remove(modifiedIndex);

        // X separation factor gets reduced for deeper nodes
        float xSeparationFactor = (float)Math.pow(xSeparationDecay,depth);

        // Draw node derivation normally
        if (!generatedChain.equals("null"))
        {
          
          // Distribute children down (considering one more node)
          int childAmount = generatedChain.length();
          float angleDelta = (float)Math.PI/(childAmount+1);
          
          // Update keys for all entries in the hash map greater than the current modified index and add the childAmount to the key
          for (Integer key : nodeXpositions.keySet()) 
          {
            if(key>modifiedIndex)
            {
              float tempX = nodeXpositions.remove(key);
              float tempY = nodeYpositions.remove(key);
              int tempD = nodeDepth.remove(key);
              nodeXpositions.put(key+childAmount - 1, tempX);
              nodeYpositions.put(key+childAmount - 1 , tempY);
              nodeDepth.put(key+childAmount - 1 , tempD);
            }
          }
          
          
          
          // Draw each of the child nodes
          for (int i=1; i<=childAmount; i++)
          {
            float angle = (float)Math.PI + i*angleDelta;
            float posXchild = posX + (float)(xSeparationFactor*nodeSeparationX*Math.cos(angle));
            float posYchild = posY - (float)(nodeSeparationY*Math.sin(angle));
            fill(255);
            line(posX, posY, posXchild, posYchild);
            fill(0,192,0);
            
            String childSymbol = Character.toString(generatedChain.charAt(i-1));
            // If this symbol is nonTerminal add its position into the node positions arraylists
            if(grammar.nonTerminalSymbols.contains(childSymbol))
            {
              fill(255,165,0);
              nodeXpositions.put(modifiedIndex + i - 1, posXchild);
              nodeYpositions.put(modifiedIndex + i - 1, posYchild);
              nodeDepth.put(modifiedIndex + i - 1, depth+1);
            }
            ellipse(posXchild, posYchild, nodeWidth, nodeWidth);
            fill(0);
            text(childSymbol, posXchild - textOffsetX, posYchild + textOffsetY);
          }
        }
        
        // Draw derivation to null children below 
        else
        {
            float posXchild = posX;
            float posYchild = posY + nodeSeparationY;
            fill(255);
            line(posX, posY, posXchild, posYchild);
            fill(0,192,0);
            ellipse(posXchild, posYchild, nodeWidth, nodeWidth);
            fill(0);
            text("/", posXchild - textOffsetX, posYchild + textOffsetY);
            
            // Update keys for all entries in the hash map greater than the current modified index and substract 1 for the empty chain
            for (Integer key : nodeXpositions.keySet()) 
            {
              if(key>modifiedIndex)
              {
                float tempX = nodeXpositions.remove(key);
                float tempY = nodeYpositions.remove(key);
                int tempD = nodeDepth.remove(key);
                nodeXpositions.put(key - 1, tempX);
                nodeYpositions.put(key - 1 , tempY);
                nodeDepth.put(key-1, tempD);
              }
            }
        }
                  
        // Draw parent node at the end
        fill(255,165,0);
        ellipse(posX, posY, nodeWidth, nodeWidth);
        fill(0);
        text(originalChain.charAt(step.modifiedIndex), posX - textOffsetX, posY + textOffsetY);
        
    }
  }
  else
  {
    fill(0);
    textSize(48);
    text("Cadena rechazada", 0.35*width, 0.5*height);
  }
}
