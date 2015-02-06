describe "Happinesspal.Models.Tag", ->
  model = undefined
  
  beforeEach ->
    model = new Happinesspal.Models.Tag()

  it "is defined", ->
    expect(Happinesspal.Models.Tag).not.toBeUndefined()
  
  it "creates instance of model", ->
    expect(model).not.toBeUndefined()
