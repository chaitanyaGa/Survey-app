describe "Happinesspal.Views.Emotions", ->
  model = undefined
  view = undefined
  
  beforeEach ->
    types = [{ id: 4, name: "Positive", color: "#15711d", tags: []}, { id: 5, name: "Negative", color: "#ff0000", tags: []}, Object { id: 7, name: "Neutral", color: "#808080", default: true, tags: []}]
    model = new Happinesspal.Models.Map(default_emotions: types, emotion_data: {xyz: {}})
    view = new Happinesspal.Views.Emotions(model: model)
    @el = view.render().$el

  it "is defined", ->
    expect(Happinesspal.Views.Emotions).not.toBeUndefined()
 
  it "renders view", ->
    expect(view.render).not.toBeUndefined()
 
  it "initialize tags collection", ->
    tags = new Happinesspal.Collections.Tags()
    expect(tags.length).toEqual(0)

  it "should render proper label", ->
    expect( view.render().$el.find('fieldset label') ).toContainText('What emotions are you experiencing?')

  it "should able to add tag", ->
    @el.find('.bent-tags').tagsManager('pushTag', 'abc')
    expect( @el.find("input[name='hidden-tags']") ).toHaveValue('xyz,abc')
