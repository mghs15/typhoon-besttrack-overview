const child_process = require('child_process');
const fs = require('fs');

const text = fs.readFileSync("bst_all.txt", "utf-8");

const set = {};

let csv = "台風識別,日時,緯度,経度,中心気圧,最大風速,50kt長径方向,50kt長径,50kt短径,30kt長径方向,30kt長径,30kt短径,上陸" + "\n";
let tInfo = "";

text.split(/\n/).forEach( line => {
  
  if(!line) return;
  
  if(!line.match(/\d/)) return;
  
  if(line.match(/^66666/)){
    //console.log(line);
    const m = line.match(/^66666 (.{4})  (.{3}) (.{4}) (.{4}) (.) (.) (.{20})              (.{8})/);
    //console.log(m);
    const yy = m[1].slice(0,2);
    const tt = m[1].slice(2,4);
    let year = (yy>50) ? "19" + yy : "20" + yy;
    tInfo = year + "T" + tt + "_" + m[7].replace(/\s+/, "");
    return; 
  }
  
  const c = line.match(/^(.{8}) (.{3}) (.) (.{3}) (.{4}) (.{4})     (.{3})     (.)(.{4}) (.{4}) (.)(.{4}) (.{4})         (.)/);
  if(c){
    csv += `${tInfo},${c[1]},${c[4]/10},${c[5]/10},${c[6]},${c[7]},${c[8]},${c[9]},${c[10]},${c[11]},${c[12]},${c[13]},${c[14]}` + "\n";
  }else{
    console.log(line);
  }
  
});

fs.writeFile(`./tyhoon-bst.csv`, csv, (e) => {
  if(e){
    console.log(`ERROR: (write file)`);
    console.error(e);
  }
});

