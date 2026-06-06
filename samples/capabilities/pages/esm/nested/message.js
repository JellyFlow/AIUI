import directModule, { directBadge, directDetails, moduleName, pageTitle } from '../constants.js';

export const nestedMessage = `${pageTitle} receives nested data from ${moduleName}`;
export const nestedRecord = {
  stage: 'page -> js -> js',
  inheritedDescription: directModule.description,
  inheritedBadge: directBadge,
  inheritedOwner: directDetails.owner,
};

const nestedModule = {
  summary: 'Nested module combines direct exports into a new payload.',
  nestedMessage,
  nestedRecord,
};

export default nestedModule;
