require("dotenv").config();

const cloudinary = require("./src/config/cloudinary.config");

async function test() {
  try {
    console.log("========== CONFIG ==========");
    console.log(cloudinary.config());

    console.log("\n========== PING ==========");
    const ping = await cloudinary.api.ping();
    console.log(ping);

    console.log("\n========== IMAGE TEST ==========");

    const imageResult = await cloudinary.uploader.upload("./test.jpg", {
      folder: "studyVault/test",
    });

    console.log(imageResult);

    console.log("\n========== PDF TEST ==========");

    const pdfResult = await cloudinary.uploader.upload("./test.pdf", {
      resource_type: "raw",
      folder: "studyVault/test",
    });

    console.log(pdfResult);

    console.log("\n✅ Everything works!");
  } catch (err) {
    console.log("\n========== ERROR ==========");

    console.dir(err, { depth: null });

    console.log("\nMessage:", err.message);
    console.log("HTTP Code:", err.http_code);

    if (err.response) {
      console.log("\nResponse:");
      console.dir(err.response, { depth: null });
    }

    if (err.error) {
      console.log("\nCloudinary Error:");
      console.dir(err.error, { depth: null });
    }

    if (err.headers) {
      console.log("\nHeaders:");
      console.dir(err.headers, { depth: null });
    }
  }
}

test();