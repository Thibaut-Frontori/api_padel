import BaseMapper from '@mappers/baseMapper';

const clubMapper = new BaseMapper('club');

export default {
    Query: {
      getClubs: async () => {
        return await clubMapper.findAll();
      }
    }
  };