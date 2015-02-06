describe "Happinesspal.Views.MapsNew", ->
  model = undefined
  view = undefined
  
  beforeEach ->
    model = new Happinesspal.Models.Map()
    collection = new Happinesspal.Collections.Maps()
    view = new Happinesspal.Views.MapsNew(model: model, collection: collection)

  it "is defined", ->
    expect(Happinesspal.Views.MapsNew).not.toBeUndefined()
 
  it "renders view", ->
    expect(view.render).not.toBeUndefined()
 
  it "loads empty collection", ->
    collection = new Happinesspal.Collections.Maps()
    expect(collection.length).toEqual(0)

  it "renders div.prettyprint with text 'AWARENESS Map'", ->
    expect( view.render().$el.find('.prettyprint') ).toContainText('AWARENESS Map')
