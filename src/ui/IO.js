/*--------------------------load system----------------------------------*/
var canvasCardComponent = null
var noteCardComponent = null
var canvasCardComponentFile = "CanvasCard.qml"
var noteCardComponentFile = "NoteCard.qml"

function load() {
    cardManager.loadCards()
    var cardNum = cardManager.cardNum()
    var cardIDs = cardManager.cardIDs()
    for (var i = 0; i < cardNum; i++) {
        var id = cardIDs[i]
        var cardType = cardManager.cardType(id)
        switch (cardType) {
        case "canvas":
            loadComponent(canvasCardComponent, canvasCardComponentFile, id)
            break
        case "note":
            loadComponent(noteCardComponent, noteCardComponentFile, id)
            break
        }
    }
}

function loadComponent(cardComponent, cardComponentFile, id) {
    // avoid duplicate loading
    if (cardComponent !== null) {
        createCard(cardComponent, id)
        return
    }

    cardComponent = Qt.createComponent(cardComponentFile)
    if (cardComponent.status === Component.Loading)
        cardComponent.statusChanged.connect(createCard)
    else
        createCard(cardComponent, id)
}

function createCard(cardComponent, id) {
    // create card from the loaded component
    if (cardComponent.status === Component.Ready) {
        // set card layer as its parent
        var card = cardComponent.createObject(bgCanvas.cardLayer, {
                                                  "x": cardManager.x(id),
                                                  "y": cardManager.y(id),
                                                  "id": id,
                                                  "cardManager": cardManager
                                              })

        card.loaded = true
    }
}

/*--------------------------save system----------------------------------*/
function savePos(id, card) {
    cardManager.setX(id, card.x)
    cardManager.setY(id, card.y)
}

function saveSize(id, card) {
    cardManager.setWidth(id, card.width)
    cardManager.setHeight(id, card.height)
}

function saveText(id, textArea) {
    cardManager.setText(id, textArea.text)
}

function saveColor(id, card) {
    cardManager.setBackgroundColor(id, card.cardBackgroundColor)
}

/*---------------------------delete--------------------------------------*/
function deleteCard(id, card) {
    cardManager.deleteCard(id)
    card.destroy()
}
