describe "Happinesspal.Views.Thoughts", ->
  model = undefined
  view = undefined
  
  beforeEach ->
    model = new Happinesspal.Models.Map()
    view = new Happinesspal.Views.Thoughts(model: model)

  it "is defined", ->
    expect(Happinesspal.Views.Thoughts).not.toBeUndefined()
 
  it "renders view", ->
    expect(view.render).not.toBeUndefined()
 
  it "initialize tags collection", ->
    tags = new Happinesspal.Collections.Tags()
    expect(tags.length).toEqual(0)
