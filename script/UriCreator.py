import json
import os

output_dir = "uris"

Type = 0
Types = ["Master", "Gold", "Silver", "Red", "Travesaño"]
Actual_Amount = [0,0,0,0,0] 
Max_Amount = [1, 10, 350, 38, 1]
img = ["bafybeiga6p44ngg5kr6wg4qekrkns2vvfodbfumqrgfjqwhhsnyhglprbu", "bafybeidlvi7yeoyol2myubmim6cm2nbmgwgrqchandmtskajaaflzzhgiy", "bafybeifc4hb6vbc7y2bqoke4zfiejnqp3xu5z6cola6uh3c5xzjriqotyi", "bafybeih7ffmuxcmkfezaozkwssmn66hvnknekhbekpwf6s3npivgdkoh34", "bafybeibec4tmqibifcmtyf7l2dbi2hvqxnkcmsyg2yr6pon2sjz5iylxfy"]

for i in range(400):
    
    if (i > 10):
        Type = 2
        if not i % 10:
            Type = 3
        if (i == 399):
            Type = 4
    elif i:
        Type = 1


    Actual_Amount[Type] += 1
    data = {
        "name": "Cadena EL TEMACH",
        "description": "Firme Compa de Hierro",
        "image": f"ipfs://{img[Type]}",
        "attributes": [
            {
                "trait_type": "Tipo",
                "value": f"{Types[Type]} ({Actual_Amount[Type]} / {Max_Amount[Type]})"
            }
        ]
    }

    file_path = os.path.join(output_dir, f"{i}.json")

    with open(file_path, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=4)

print("Done")