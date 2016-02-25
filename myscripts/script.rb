
      img="/home/nikunj/Nikunj/pramod/Cloudinary image optimization/testImages/880kb.jpg"
      img="/home/nikunj/Nikunj/pramod/Cloudinary image optimization/testImages/1.2MBJPG.jpg"
      img="/home/nikunj/Nikunj/pramod/Cloudinary image optimization/testImages/159kbJPG.jpeg"
      img="/home/nikunj/Nikunj/pramod/Cloudinary image optimization/testImages/1.3GIF.gif"
      img="/home/nikunj/Nikunj/pramod/Cloudinary image optimization/testImages/5.7PNG.png"
      img="/home/nikunj/Nikunj/pramod/Cloudinary image optimization/testImages/2MBPNG.png"
      img="/home/nikunj/Nikunj/pramod/Cloudinary image optimization/testImages/11.14MB.jpg"
      img="/home/nikunj/Nikunj/pramod/Cloudinary image optimization/testImages/1.2MBJPG.jpg"
      i=1
      images=ProductsImport.new.upload_to_cloudinary(img)
      hsh{}
      hsh[:name] = "testProduct"+i.to_s;
      hsh[:description] = "testDesc"+i.to_s;
      hsh[:applicablePrice] = '1'
      hsh[:productCondition] = "new"
      hsh[:categoryId] = 619
      hsh[:userId] = 2424
      hsh[:city] = "kolkata"

      hsh[:locality] = ""
      hsh[:latitude] = 0
      hsh[:longitude] = 0
      hsh[:googlePlaceId] = ""
      hsh[:source] = "ADMIN"
      
      
      hsh1=hsh
      hsh2=hsh
      hsh3=hsh
      hsh1[:images] = images.to_a
      hsh2[:images] = images2.to_a
      hsh3[:images] = images3.to_a
      write_api('post','products',hsh1.to_json,"message") 
      write_api('post','products',hsh2.to_json,"message") 
      write_api('post','products',hsh3.to_json,"message") 


      str1=hsh1.to_json.gsub("","").gsub("/",)
     {"name":"testProduct1","description":"testDesc1","applicablePrice":"1","productCondition":"new","categoryId":619,"userId":2424,"city":"kolkata","locality":"","latitude":0,"longitude":0,"googlePlaceId":"","source":"ADMIN","images":[{"original":"http://res.cloudinary.com/shopo/image/upload/v1442836812/ckzxiysvwnlwfvogy8u7.jpg","originalHeight":7049,"originalWidth":10315,"predominantColor":{"google":[["yellow",52.3],["brown",22.1],["green",10.4],["teal",9.3]]},"thumb":"http://res.cloudinary.com/shopo/image/upload/c_thumb,f_auto,h_72,q_80,w_72/v1442836812/ckzxiysvwnlwfvogy8u7.jpg","thumbHeight":72,"thumbWidth":72,"medium":"http://res.cloudinary.com/shopo/image/upload/c_fit,f_auto,q_80,w_560/v1442836812/ckzxiysvwnlwfvogy8u7.jpg","mediumHeight":383,"mediumWidth":560,"listing":"http://res.cloudinary.com/shopo/image/upload/c_fit,f_auto,q_80,w_1080/v1442836812/ckzxiysvwnlwfvogy8u7.jpg","listingHeight":738,"listingWidth":1080}]}
     {"name":"testOriginal","description":"testDesc1","applicablePrice":"1","productCondition":"new","categoryId":619,"userId":2424,"city":"kolkata","locality":"","latitude":0,"longitude":0,"googlePlaceId":"","source":"ADMIN","images":[{"original":"http://res.cloudinary.com/shopo/image/upload/v1442838454/dlhm1rs28rdyxqk4ximi.jpg","originalHeight":7049,"originalWidth":10315,"predominantColor":{"google":[["yellow",52.3],["brown",22.1],["green",10.4],["teal",9.3]]},"thumb":"http://res.cloudinary.com/shopo/image/upload/c_thumb,h_72,w_72/v1442838454/dlhm1rs28rdyxqk4ximi.jpg","thumbHeight":72,"thumbWidth":72,"medium":"http://res.cloudinary.com/shopo/image/upload/c_fit,w_560/v1442838454/dlhm1rs28rdyxqk4ximi.jpg","mediumHeight":383,"mediumWidth":560,"listing":"http://res.cloudinary.com/shopo/image/upload/c_fit,w_1080/v1442838454/dlhm1rs28rdyxqk4ximi.jpg","listingHeight":738,"listingWidth":1080}]}
     {"name":"testProduct2","description":"testDesc2","applicablePrice":"1","productCondition":"new","categoryId":619,"userId":2424,"city":"kolkata","locality":"","latitude":0,"longitude":0,"googlePlaceId":"","source":"ADMIN","images":[{"original":"http://res.cloudinary.com/shopo/image/upload/v1442840681/vtjkhjuujiheifjhfixc.jpg","originalHeight":2736,"originalWidth":3648,"predominantColor":{"google":[["brown",52.2],["green",23.6],["yellow",8.2],["black",6.3],["teal",6.3]]},"thumb":"http://res.cloudinary.com/shopo/image/upload/c_thumb,f_auto,h_72,q_80,w_72/v1442840681/vtjkhjuujiheifjhfixc.jpg","thumbHeight":72,"thumbWidth":72,"medium":"http://res.cloudinary.com/shopo/image/upload/c_fit,f_auto,q_80,w_560/v1442840681/vtjkhjuujiheifjhfixc.jpg","mediumHeight":420,"mediumWidth":560,"listing":"http://res.cloudinary.com/shopo/image/upload/c_fit,f_auto,q_80,w_1080/v1442840681/vtjkhjuujiheifjhfixc.jpg","listingHeight":810,"listingWidth":1080}]}
     {"name":"testProduct2","description":"testDesc2","applicablePrice":"1","productCondition":"new","categoryId":619,"userId":2424,"city":"kolkata","locality":"","latitude":0,"longitude":0,"googlePlaceId":"","source":"ADMIN","images":[{"original":"http://res.cloudinary.com/shopo/image/upload/v1442840681/vtjkhjuujiheifjhfixc.jpg","originalHeight":2736,"originalWidth":3648,"predominantColor":{"google":[["brown",52.2],["green",23.6],["yellow",8.2],["black",6.3],["teal",6.3]]},"thumb":"http://res.cloudinary.com/shopo/image/upload/c_thumb,f_auto,h_72,q_80,w_72/v1442840681/vtjkhjuujiheifjhfixc.jpg","thumbHeight":72,"thumbWidth":72,"medium":"http://res.cloudinary.com/shopo/image/upload/c_fit,f_auto,q_80,w_560/v1442840681/vtjkhjuujiheifjhfixc.jpg","mediumHeight":420,"mediumWidth":560,"listing":"http://res.cloudinary.com/shopo/image/upload/c_fit,f_auto,q_80,w_1080/v1442840681/vtjkhjuujiheifjhfixc.jpg","listingHeight":810,"listingWidth":1080}]}
