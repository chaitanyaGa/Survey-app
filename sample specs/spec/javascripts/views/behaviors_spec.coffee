describe "Happinesspal.Views.Behaviors", ->
  model = undefined
  view = undefined
  
  beforeEach ->
    model = new Happinesspal.Models.Map()
    view = new Happinesspal.Views.Behaviors(model: model)

  it "is defined", ->
    expect(Happinesspal.Views.Behaviors).not.toBeUndefined()
 
  it "renders view", ->
    expect(view.render).not.toBeUndefined()
 
  it "initialize tags collection", ->
    tags = new Happinesspal.Collections.Tags()
    expect(tags.length).toEqual(0)
