export const idlFactory = ({ IDL }) => {
  return IDL.Service({
    'getSiteMessage' : IDL.Func([], [IDL.Text], ['query']),
    'setSiteMessage' : IDL.Func([IDL.Text], [IDL.Text], []),
  });
};
export const init = ({ IDL }) => { return []; };
