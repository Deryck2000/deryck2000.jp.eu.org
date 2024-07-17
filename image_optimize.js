import { functionOptimizeImages } from 'images-folder-optimizer';

functionOptimizeImages({
    stringOriginFolder: 'assets/creations-original',
    stringDestinationFolder: 'assets/creations',
    arrayOriginFormats: ['jpg', 'png'],
    arrayDestinationFormats: ['webp', 'avif'],
}).then((results) => {
    console.table(results);
});