describe "Happinesspal.Views.MapsShow", ->
  model = undefined
  view = undefined
  
  beforeEach ->
    model = new Happinesspal.Models.Map()
    view = new Happinesspal.Views.MapsShow(model: model)

  it "is defined", ->
    expect(Happinesspal.Views.MapsShow).not.toBeUndefined()
  
  it "renders view", ->
    expect(view.render).not.toBeUndefined()

  it "loads collection", ->
    collection = new Happinesspal.Collections.Maps()
    expect(collection).not.toBeUndefined()
 
  it "renders div.prettyprint with text 'AWARENESS Map'", ->
    expect( view.render().$el.find('.prettyprint') ).toContainText('AWARENESS Map')
