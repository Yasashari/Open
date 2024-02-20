```solidity

// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.17;

import "hardhat/console.sol" ;

contract bits {


   struct Result {
    uint Number ;
    uint TotalOnes ;
    uint  Length  ;
   }


   uint[] public totalOneArray ;
   uint[] public totalOneArraySorted ;
   uint[] public numbers ;
   uint[] public Leng ;
  

   function sortfinal(uint[] memory numberList) public  returns(uint[] memory) {
       // Create a array for total ones & its bitarray length
       // uint[] memory result = new uint[](n);
      
      // uint[] memory result =  new uint[](2*numberList.length) ;

      Result[] memory result =  new Result[](numberList.length) ;
   //  uint[] memory totalOneArray =  new uint[](numberList.length) ;
       
        for(uint i ; i < numberList.length ; i++) {
          (uint totalOnes, uint len)  =  calculateOnesandLen(findBits(numberList[i])) ;
            result[i].Number = numberList[i];
            result[i].TotalOnes = totalOnes ;  // store totalOnes 
            result[i].Length = len ;    // store its length
            totalOneArray.push(totalOnes);
            console.log("totalOneArray :" , i, totalOneArray[i]);
            numbers.push(numberList[i]); 
            Leng.push(len); 
        }
        
      //  return result;
     // Sorting to acending order

         uint[] memory totalOneArrayCopied =  new uint[](numberList.length) ;
                totalOneArrayCopied    =  totalOneArray ;
                for(uint i ; i < totalOneArrayCopied.length; i++) {
                   console.log("totalOneArrayCopied :", i , totalOneArrayCopied[i]);
                }
                

    //    uint[] memory totalOneArraySorted =  new uint[](numberList.length) ;
                totalOneArraySorted    =  sort(totalOneArrayCopied) ;
                for(uint i ; i < totalOneArraySorted.length; i++) {
                   console.log("totalOneArraySorted :", i , totalOneArraySorted[i]);
                }

                for(uint i ; i < totalOneArray.length; i++) {
                   console.log("totalOneArray :", i , totalOneArray[i]);
                }
     // Needs to find the relevant number in sorted array
     //   uint[] memory finalResult =  new uint[](numberList.length) ;
     //   for(uint i=0 ; i < numberList.length ; i++ ) {
     //      for(uint j=0 ; j < numberList.length ;  j++ ) {
     //               console.log("i :" , i);
     //               console.log("j :" , j);
     //          if(totalOneArraySorted[i] == totalOneArrayCopied[j] ) {
     //               console.log(" totalOneArraySorted[i] :", i , totalOneArraySorted[i]) ;
     //               console.log(" totalOneArray[j] :", j , totalOneArrayCopied[j]) ;
     //               console.log(" jM :", j) ;
     //               console.log(" iM :", i) ;
     //               finalResult[i] = numberList[j] ;
     //               console.log("finalResult :", finalResult[i]) ;
     //          }

              
           }
        


      //  return finalResult ;

     //   for (uint j ; j < numberList.length ; j++) {
     //       for(uint k ; k < numberList.length ; k++) {
     //           if(result[j].TotalOnes < result[k].TotalOnes) {
                          
     //           }
     //       }
     //   }

     

   


   function finalR() public view returns(uint[] memory) {
      uint[] memory finalResult =  new uint[](totalOneArray.length) ;
        for(uint i=0 ; i < totalOneArray.length ; i++ ) {
           for(uint j=0 ; j < totalOneArray.length ;  j++ ) {
                    console.log("i :" , i);
                    console.log("j :" , j);
                  
               if(totalOneArraySorted[i] == totalOneArray[j] ) {
                    console.log(" totalOneArraySorted[i] :", i , totalOneArraySorted[i]) ;
                    console.log(" totalOneArray[j] :", j , totalOneArray[j]) ;
                    console.log(" jM :", j) ;
                    console.log(" iM :", i) ;
                   // if(i > 0 && numbers[j] >= finalResult[i-1]) {
                        finalResult[i] = numbers[j] ;
                 //   }
                   
                    console.log("finalResult :", finalResult[i]) ;
               }

               

              
           }

          
   }
 return finalResult ; 
   }


   function min(uint len1 , uint len2) public pure returns(uint ) {
       len1 > len2 ? len2 : len1 ;
   }
   function findBits(uint256 number) public pure returns(uint[] memory ) {
      //  console.log("start") ;
        uint len = log2(number) ;
        //Correction for the length
        if (2**len!=number) {
            len = len -1;
        }


        uint[] memory bitArray = new uint[](len + 1) ;
        uint i ;
        while (number > 0) {
        //    console.log(2);
        if (number % 2 == 0) {
           bitArray[len - i]= 0; // Reverse the order of filling array. 
        } else {
            bitArray[len - i]=1; 
        }
          
           number =  number / 2 ;
           i +=1 ;
      //     console.log(i);
        }
     //  console.log("end");
       return bitArray ;
       
    }


    function calculateOnesandLen(uint[] memory bitarray) public pure returns(uint , uint) {
       uint totalOnes ;
       for(uint i ; i< bitarray.length ; i++){
            if ( bitarray[i] == 1 ) {
              totalOnes ++ ;
            } 
       }
       return (totalOnes, bitarray.length) ;
    }


    function log2(uint x) public pure returns (uint y){
   assembly {
        let arg := x
        x := sub(x,1)
        x := or(x, div(x, 0x02))
        x := or(x, div(x, 0x04))
        x := or(x, div(x, 0x10))
        x := or(x, div(x, 0x100))
        x := or(x, div(x, 0x10000))
        x := or(x, div(x, 0x100000000))
        x := or(x, div(x, 0x10000000000000000))
        x := or(x, div(x, 0x100000000000000000000000000000000))
        x := add(x, 1)
        let m := mload(0x40)
        mstore(m,           0xf8f9cbfae6cc78fbefe7cdc3a1793dfcf4f0e8bbd8cec470b6a28a7a5a3e1efd)
        mstore(add(m,0x20), 0xf5ecf1b3e9debc68e1d9cfabc5997135bfb7a7a3938b7b606b5b4b3f2f1f0ffe)
        mstore(add(m,0x40), 0xf6e4ed9ff2d6b458eadcdf97bd91692de2d4da8fd2d0ac50c6ae9a8272523616)
        mstore(add(m,0x60), 0xc8c0b887b0a8a4489c948c7f847c6125746c645c544c444038302820181008ff)
        mstore(add(m,0x80), 0xf7cae577eec2a03cf3bad76fb589591debb2dd67e0aa9834bea6925f6a4a2e0e)
        mstore(add(m,0xa0), 0xe39ed557db96902cd38ed14fad815115c786af479b7e83247363534337271707)
        mstore(add(m,0xc0), 0xc976c13bb96e881cb166a933a55e490d9d56952b8d4e801485467d2362422606)
        mstore(add(m,0xe0), 0x753a6d1b65325d0c552a4d1345224105391a310b29122104190a110309020100)
        mstore(0x40, add(m, 0x100))
        let magic := 0x818283848586878898a8b8c8d8e8f929395969799a9b9d9e9faaeb6bedeeff
        let shift := 0x100000000000000000000000000000000000000000000000000000000000000
        let a := div(mul(x, magic), shift)
        y := div(mload(add(m,sub(255,a))), shift)
        y := add(y, mul(256, gt(arg, 0x8000000000000000000000000000000000000000000000000000000000000000)))
    }  
}


function sort(uint[] memory data) public pure returns(uint[] memory) {
       quickSort(data, int(0), int(data.length - 1));
       return data;
    }
    
    function quickSort(uint[] memory arr, int left, int right) internal pure {
        int i = left;
        int j = right;
        if(i==j) return;
        uint pivot = arr[uint(left + (right - left) / 2)];
        while (i <= j) {
            while (arr[uint(i)] < pivot) i++;
            while (pivot < arr[uint(j)]) j--;
            if (i <= j) {
                (arr[uint(i)], arr[uint(j)]) = (arr[uint(j)], arr[uint(i)]);
                i++;
                j--;
            }
        }
        if (left < j)
            quickSort(arr, left, j);
        if (i < right)
            quickSort(arr, i, right);
    }

    
}

```
