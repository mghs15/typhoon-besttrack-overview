const child_process = require('child_process');
const fs = require('fs');

const text = fs.readFileSync("tyhoon-bst.csv", "utf-8");

const set = {};

text.split(/\n/).forEach( line => {
  
  if(!line) return;
  
  const c = line.split(",");
  
  if(!c[0].match(/\d/)) return; 
  
  const name = `${c[0]}`;
  if(!set[name]) set[name] = [];
  set[name].push(c);
  
});

const geojson = {
  "type": "FeatureCollection",
  "features": []
};

const geojsonPoint = {
  "type": "FeatureCollection",
  "features": []
};

for( let name in set ){
  
  /* 後できちんと作りたい
  set[name].sort((a, b) => {
    
    
    // 月で比較
    if(+a[1] != +b[1]){
      return (+a[1] - +b[1])
    }
    // 日で比較
    if(+a[2] != +b[2]){
      return (+a[2] - +b[2])
    }
    // 時刻で比較
    return (+a[3] - +b[3])
  });
  */
  
  const f = {
    "type": "Feature",
    "geometry": {
      "type": "LineString",
      "coordinates": []
    },
    "properties": {
      "name": name,
      // "_color": "#0000ff",
      // "_opacity": 0.8,
      // "_weight": 0.5
    }
  };
  
  let minp = 9999;
  set[name].forEach( c => {
      f.geometry.coordinates.push([+c[3], +c[2]]);
      minp = Math.min(+c[4], minp);
      f.properties["最低中心気圧"] = minp;
      if(c[12].match(/\S/)){
        f.properties["上陸回数"] = f.properties["上陸回数"] ? f.properties["上陸回数"] + 1 : 1;
        
        const ji = f.properties["上陸回数"];
        if(ji > 1) console.log(f.properties.name);
        
        f.properties[`上陸日時_${ji}`] = c[1];
        f.properties[`上陸緯度_${ji}`] = +c[2];
        f.properties[`上陸経度_${ji}`] =  +c[3];
        f.properties[`上陸中心気圧_${ji}`] = +c[4];
        
        // f.properties["_color"] = "#ff0000";
        
        const pt = {
          "type": "Feature",
          "geometry": {
            "type": "Point",
            "coordinates": [+c[3], +c[2]]
          },
          "properties": {
            "name": name + "_上陸" + ji,
            "上陸回数": ji,
            "上陸日時": c[1],
            "上陸緯度": +c[2],
            "上陸経度": +c[3],
            "上陸中心気圧": +c[4],
          }
        };
        
        geojsonPoint.features.push(pt);
      }
  });
  
  geojson.features.push(f);
  
}

fs.writeFile(`./tyhoon-course.geojson`, JSON.stringify(geojson, null, 2), (e) => {
  if(e){
    console.log(`ERROR: (write file)`);
    console.error(e);
  }
});

fs.writeFile(`./tyhoon-jouriku-point.geojson`, JSON.stringify(geojsonPoint, null, 2), (e) => {
  if(e){
    console.log(`ERROR: (write file)`);
    console.error(e);
  }
});

