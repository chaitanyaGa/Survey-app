describe "Happinesspal.Views.Needs", ->
  model = undefined
  view = undefined
  
  beforeEach ->
    model = new Happinesspal.Models.Map()
    view = new Happinesspal.Views.Needs(model: model)

  it "is defined", ->
    expect(Happinesspal.Views.Needs).not.toBeUndefined()
 
  it "renders view", ->
    expect(view.render).not.toBeUndefined()
 
  it "initialize tags collection", ->
    tags = new Happinesspal.Collections.Tags()
    expect(tags.length).toEqual(0)
