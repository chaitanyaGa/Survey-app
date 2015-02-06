describe "Happinesspal.Views.Circumstances", ->
  model = undefined
  view = undefined
  
  beforeEach ->
    model = new Happinesspal.Models.Map()
    view = new Happinesspal.Views.Circumstances(model: model)

  it "is defined", ->
    expect(Happinesspal.Views.Circumstances).not.toBeUndefined()
 
  it "renders view", ->
    expect(view.render).not.toBeUndefined()
 
  it "initialize tags collection", ->
    tags = new Happinesspal.Collections.Tags()
    expect(tags.length).toEqual(0)
  
  #TODO:
  #it "renders circumstances input form", ->
  #  expect( view.render().$el.find('form') ).not.toBeEmpty()
  
  #it "renders circumstance tags input", ->
  #  expect(view.render().$el.find('form .bent-tags')).toBe('input')
