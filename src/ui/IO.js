/*--------------------------load system----------------------------------*/
var canvasCardComponent = null
var noteCardComponent = null
var canvasCardComponentFile = "CanvasCard.qml"
var noteCardComponentFile = "NoteCard.qml"

function load() {
    CardManager.loadCards()
    var cardNum = CardManager.cardNum()
    var cardIDs = CardManager.cardIDs()
    for (var i = 0; i < cardNum; i++) {
        var id = cardIDs[i]
        var cardType = CardManager.cardType(id)
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
                                                  "x": CardManager.x(id),
                                                  "y": CardManager.y(id),
                                                  "id": id
                                              })

        card.loaded = true
    }
}

/*--------------------------save system----------------------------------*/
function savePos(id, card) {
    CardManager.setX(id, card.x)
    CardManager.setY(id, card.y)
}

function saveSize(id, card) {
    CardManager.setWidth(id, card.width)
    CardManager.setHeight(id, card.height)
}

function saveText(id, textArea) {
    CardManager.setText(id, textArea.text)
}

function saveColor(id, card) {
    CardManager.setBackgroundColor(id, card.cardBackgroundColor)
}

/*---------------------------delete--------------------------------------*/
function deleteCard(id, card) {
    CardManager.deleteCard(id)
    card.destroy()
}
