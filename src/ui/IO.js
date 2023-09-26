/*--------------------------load system----------------------------------*/
var canvasCardComponent = null
var noteCardComponent = null
var canvasCardComponentFile = "CanvasCard.qml"
var noteCardComponentFile = "NoteCard.qml"

function load() {
    cardManager.loadCards()
    var cardNum = cardManager.cardNum()
    for (var i = 0; i < cardNum; i++) {
        var cardType = cardManager.cardType(i)
        switch (cardType) {
        case "canvas":
            loadComponent(canvasCardComponent, canvasCardComponentFile, i)
            break
        case "note":
            loadComponent(noteCardComponent, noteCardComponentFile, i)
            break
        }
    }
}

function loadComponent(cardComponent, cardComponentFile, index) {
    // avoid duplicate loading
    if (cardComponent !== null) {
        createCard(cardComponent, index)
        return
    }

    cardComponent = Qt.createComponent(cardComponentFile)
    if (cardComponent.status === Component.Loading)
        cardComponent.statusChanged.connect(createCard)
    else
        createCard(cardComponent, index)
}

function createCard(cardComponent, index) {
    // create card from the loaded component
    if (cardComponent.status === Component.Ready) {
        // set card layer as its parent
        var card = cardComponent.createObject(bgCanvas.cardLayer, {
                                                  "x": cardManager.x(index),
                                                  "y": cardManager.y(index),
                                                  "cardIndex": index,
                                                  "cardManager": cardManager
                                              })

        card.loaded = true
    }
}

/*--------------------------save system----------------------------------*/
function savePos(cardIndex, card) {
    cardManager.setX(cardIndex, card.x)
    cardManager.setY(cardIndex, card.y)
}

function saveSize(cardIndex, card) {
    cardManager.setWidth(cardIndex, card.width)
    cardManager.setHeight(cardIndex, card.height)
}

function saveText(cardIndex, textArea) {
    cardManager.setText(cardIndex, textArea.text)
}

function saveColor(cardIndex, card) {
    cardManager.setBackgroundColor(cardIndex, card.cardBackgroundColor)
}
