import QtQuick
import "js/IO.js" as IO
import MemoPad.CardManager
import MemoPad.CommandManager

Item {
    id: nodeLayer
    width: parent.width
    height: parent.height
    anchors.fill: parent

    signal loadCanvasSignal(string canvasID)

    // set a card to the top card by id
    function setCardToTop(cardID) {
        // add cards to an array
        var cardArray = []
        for (var i = 0; i < nodeLayer.children.length; i++) {
            var currentID = nodeLayer.children[i].cardID
            if (currentID === cardID)
                nodeLayer.children[i].z = nodeLayer.children.length + 1
            cardArray.push({
                               "cardID": nodeLayer.children[i].cardID,
                               "z": nodeLayer.children[i].z
                           })
        }
        // sort array by z
        cardArray.sort(function (a, b) {
            return a.z - b.z
        })
        // reassign z by ascending order
        for (var j = 0; j < nodeLayer.children.length; j++) {
            currentID = nodeLayer.children[j].cardID
            for (var k = 0; k < cardArray.length; k++)
                if (currentID === cardArray[k].cardID)
                    nodeLayer.children[j].z = k + 1 // the card order z is 1-based
            IO.savePos(currentID, nodeLayer.children[j], false)
        }
    }
}
