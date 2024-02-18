from openai import OpenAI

client = OpenAI(api_key = "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")

response = client.chat.completions.create(
  model="gpt-4-vision-preview",
  messages=[
    {
      "role": "user",
      "content": [
        {"type": "text", "text":
        "OUTPUT PARAMETERS: HEADER - bolded, DESCRIPTION - italic, BRACKETS - description of what to write, CURLY BRACKETS - as written" 
        "Is it food? IF NO RESPOND: {DO NOT EAT THAT [OBJECT]}" +
        "IF FOOD RESPOND:" +
        "HEADER[Food Name]"+
        "DESCRIPTION[brief decription no more then 10 words]"+
        "HEADER{Potential Allergens:}"+
        "BULLET POINTS - [bullet point specific food items or contents it is made out of that may cause allergies]"+
        "HEADER{Estimated Caloric Content:}"+
        "BULLET POINTS[Number of same food items if countable and estimated calloriesfor each]"+
        "HEADER{Total Calories:}"+
        "BULLET POINT[Estimate total calories of the all the foods]"+
        "DESCRIPTION[Potential health beneifts and risks of the foods no more then 50 words]"},
        {
          "type": "image_url",
          "image_url": {
            "url": "https://myplate-prod.azureedge.us/sites/default/files/styles/recipe_525_x_350_/public/2020-10/FlavorfulFriedRice527x323.jpg",
          },
        },
      ],
    }
  ],
  max_tokens=300,
)

print(response.choices[0])