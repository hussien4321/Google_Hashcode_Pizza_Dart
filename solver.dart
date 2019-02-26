import './coord.dart';
import './pizza.dart';
class Solver {

  Pizza pizza;
  int currentNumberOfSolvedRows;
  List<Coord> slicesFound;

  Solver(this.pizza){
    currentNumberOfSolvedRows = 0;
    slicesFound = [];
  }

  List<Coord> solve(){
    
    while(currentNumberOfSolvedRows < pizza.heightOfPizza){
      // print('subtracting rows with current start point at $currentNumberOfSolvedRows');
      _findTheOptimalSetOfRowsAndAddSlices();
    }
    return slicesFound;
  }



  int currentX;
  int currentY;
  int currentHeight;
  int currentWidth;
  int tempScore;
  List<Coord> biggestSlicesPerRow;


  _findTheOptimalSetOfRowsAndAddSlices(){
    currentX = 0;
    currentY = currentNumberOfSolvedRows;
    currentHeight = 1;
    currentWidth = 1;
    tempScore = -1;

    while(verticalPointerIsOnPizza){
      List<Coord> currentSlicesAtThisHeight = _checkForSlicesAtThisHeight();
      int currentScoreAtThisHeight = currentSlicesAtThisHeight.fold(0, (sum, coord) => sum + coord.size);

      // print("Current Height is $currentHeight, w/x,y ($currentX,$currentY) current score at this height is $currentScoreAtThisHeight");

      if(currentScoreAtThisHeight < tempScore){
        // print("found a good solution at height $currentHeight");
        currentNumberOfSolvedRows = currentY + currentWidth - 1;
        currentY = currentNumberOfSolvedRows;
        break;
      }
      tempScore = currentScoreAtThisHeight;
      biggestSlicesPerRow =  currentSlicesAtThisHeight;
      currentHeight++;
      currentNumberOfSolvedRows = currentY + currentWidth;
      currentY =currentNumberOfSolvedRows;
    }

    slicesFound.addAll(biggestSlicesPerRow);


  }

  bool get verticalPointerIsOnPizza => currentY + currentHeight -1 < pizza.heightOfPizza;

  List<Coord> _checkForSlicesAtThisHeight(){

    List<Coord> slicesForThisHeight = []; 
    while(currentX < pizza.widthOfPizza){
      _expandCurrentSelectionToMaxSize();
      _checkIfValidToppingsAndUpdate(slicesForThisHeight);
    }
    currentX = 0;
    return slicesForThisHeight;
  }


  Coord get getCurrentCoords => Coord(left: currentX, right: currentX+currentWidth - 1, top: currentY, bottom: currentY + currentHeight-1);



  _expandCurrentSelectionToMaxSize(){
    while(pizza.isValidSizeSlice(getCurrentCoords)){
      bool success = _attemptToExpandToTheRight();
      if(!success){        
        // print('expanded slice till $getCurrentCoords');
        break;
      }
    }
  }

  bool _attemptToExpandToTheRight() {
    currentWidth++;
    if(!pizza.isValidSizeSlice(getCurrentCoords) || !pizza.isValidSlice(getCurrentCoords)){
      currentWidth--;
      return false;
    }
    return true;
  }

  _checkIfValidToppingsAndUpdate(List<Coord> slicesForThisHeight) {
    if(pizza.isValidToppingSlice(getCurrentCoords)){
      // print("adding slice to data!");
      slicesForThisHeight.add(getCurrentCoords);
      currentX = currentX + currentWidth;
    }
    else{
      currentX++;
    }
    currentWidth = 1;
    return slicesForThisHeight;

  }
}