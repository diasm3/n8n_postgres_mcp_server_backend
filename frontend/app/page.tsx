import ComplaintForm from '@/components/ComplaintForm';

export default function Home() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-3xl mx-auto">
        {/* 헤더 */}
        <div className="text-center mb-10">
          <h1 className="text-4xl font-bold text-gray-900 mb-4">
            중고나라 고객센터
          </h1>
          <p className="text-lg text-gray-600">
            문의사항이 있으시면 아래 양식을 작성해주세요
          </p>
        </div>

        {/* 폼 카드 */}
        <div className="bg-white rounded-2xl shadow-xl p-8">
          <ComplaintForm />
        </div>

        {/* 푸터 */}
        <div className="mt-8 text-center text-sm text-gray-500">
          <p>
            영업시간: 평일 09:00 - 18:00 | 주말/공휴일 제외
          </p>
          <p className="mt-2">
            긴급한 문의는 고객센터(1588-0000)로 연락주세요
          </p>
        </div>
      </div>
    </div>
  );
}
