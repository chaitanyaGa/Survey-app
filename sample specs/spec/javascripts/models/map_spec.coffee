describe "Happinesspal.Models.Map", ->
  model = undefined
  
  beforeEach ->
    model = new Happinesspal.Models.Map()

  it "is defined", ->
    expect(Happinesspal.Models.Map).not.toBeUndefined()
  
  it "creates instance of model", ->
    expect(model).not.toBeUndefined()
  
  it "defines URL", ->
    expect(model.url).not.toBeEmpty()
  
  it "URL is valid", ->
    expect(model.url).toEqual(Happinesspal.url_prefix + "/maps")
    
  it "circumstance data to be empty by default", ->
    expect(model.get('circumstance_data')).toEqual({})
  
  it "wants data to be empty by default", ->
    expect(model.get('need_data')).toEqual({})
  
  it "behavior data to be empty by default", ->
    expect(model.get('behavior_data')).toEqual({})
  
  it "emotion data to be empty by default", ->
    expect(model.get('emotion_data')).toEqual({})

  it "thought data to be empty by default", ->
    expect(model.get('thought_data')).toEqual({})
