import QtQuick
import "IO.js" as IO
import MemoPad.CardManager
import MemoPad.CommandManager

Item {
    id: cardLayer
    width: parent.width
    height: parent.height
    anchors.fill: parent

    signal loadCanvasSignal(string canvasID)

    // set a card to the top card by id
    function setCardToTop(cardID) {
        // add cards to an array
        var cardArray = []
        for (var i = 0; i < cardLayer.children.length; i++) {
            var currentID = cardLayer.children[i].id
            if (currentID === cardID)
                cardLayer.children[i].z = cardLayer.children.length + 1
            cardArray.push({
                               "id": cardLayer.children[i].id,
                               "z": cardLayer.children[i].z
                           })
        }
        // sort array by z
        cardArray.sort(function (a, b) {
            return a.z - b.z
        })
        // reassign z by ascending order
        for (var j = 0; j < cardLayer.children.length; j++) {
            currentID = cardLayer.children[j].id
            for (var k = 0; k < cardArray.length; k++)
                if (currentID === cardArray[k].id)
                    cardLayer.children[j].z = k + 1 // the card order z is 1-based
            IO.savePos(currentID, cardLayer.children[j])
            console.log(cardLayer.children[j], ": ", cardLayer.children[j].z)
        }
    }
}
