package kg.manurov.bankmvc.service;

import kg.manurov.bankmvc.dto.cards.CardBlockRequestCreateDto;
import kg.manurov.bankmvc.dto.cards.CardBlockRequestDto;
import kg.manurov.bankmvc.dto.mappers.CardBlockRequestMapper;
import kg.manurov.bankmvc.entities.Card;
import kg.manurov.bankmvc.entities.CardBlockRequest;
import kg.manurov.bankmvc.enums.CardRequestStatus;
import kg.manurov.bankmvc.repositories.CardBlockRequestRepository;
import kg.manurov.bankmvc.repositories.CardRepository;
import kg.manurov.bankmvc.repositories.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.NoSuchElementException;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional
public class CardBlockRequestService {

    private final CardBlockRequestRepository cardBlockRequestRepository;
    private final CardBlockRequestMapper mapper;
    private final CardRepository cardRepository;
    private final UserRepository userRepository;
    private final CardService cardService;

    public CardBlockRequestDto createBlockRequest(Long userId, CardBlockRequestCreateDto request) {
        log.info("Создание запроса на блокировку карты с ID: {}",
                request.getCardId());

        Card card = cardRepository.findById(userId)
                .orElseThrow(() -> new NoSuchElementException("Пользователь не найден"));
        CardBlockRequest blockRequest = mapper.toEntity(card,request);
        CardBlockRequest savedRequest = cardBlockRequestRepository.save(blockRequest);

        log.info("Запрос на блокировку карты создан с ID: {}", savedRequest.getId());
        return mapper.mapToDto(savedRequest);
    }


    public CardBlockRequestDto approveBlockRequest(Long requestId, String adminComment) {
        log.info("Одобрение запроса на блокировку с ID: {} администратором.",
                requestId);

        CardBlockRequest blockRequest = cardBlockRequestRepository.findById(requestId)
                .orElseThrow(() -> new NoSuchElementException("Запрос на блокировку не найден"));

        if (!CardRequestStatus.PENDING.name().equals(blockRequest.getStatus())) {
            throw new IllegalArgumentException("Запрос уже обработан");
        }
        cardService.blockCard(blockRequest.getCard().getId(), blockRequest.getReason());


        blockRequest.setStatus(CardRequestStatus.APPROVED.name());
        blockRequest.setAdminComment(adminComment);
        cardBlockRequestRepository.save(blockRequest);

        log.info("Запрос на блокировку одобрен, карта заблокирована");

        return mapper.mapToDto(blockRequest);
    }


    public CardBlockRequestDto rejectBlockRequest(Long requestId, String adminComment) {
        log.info("Отклонение запроса на блокировку с ID: {} администратором.",
                requestId);

        CardBlockRequest blockRequest = cardBlockRequestRepository.findById(requestId)
                .orElseThrow(() -> new NoSuchElementException("Запрос на блокировку не найден"));

        if (!CardRequestStatus.PENDING.name().equals(blockRequest.getStatus())) {
            throw new IllegalArgumentException("Запрос уже обработан");
        }

        blockRequest.setStatus(CardRequestStatus.REJECTED.name());
        blockRequest.setAdminComment(adminComment);
        CardBlockRequest savedRequest = cardBlockRequestRepository.save(blockRequest);

        log.info("Запрос на блокировку отклонен");
        return mapper.mapToDto(savedRequest);
    }


    public void cancelBlockRequest(Long requestId) {
        log.info("Отмена запроса на блокировку с ID: {} автором.", requestId);

        CardBlockRequest blockRequest = cardBlockRequestRepository.findById(requestId)
                .orElseThrow(() -> new NoSuchElementException("Запрос на блокировку не найден"));

        if (!CardRequestStatus.PENDING.name().equals(blockRequest.getStatus())) {
            throw new IllegalArgumentException("Можно отменить только запросы в статусе 'Ожидание'");
        }
        blockRequest.setStatus(CardRequestStatus.CANCELLED.name());
        cardBlockRequestRepository.save(blockRequest);
        log.info("Запрос на блокировку отменен пользователем");
    }


    @Transactional(readOnly = true)
    public Page<CardBlockRequestDto> getAllBlockRequests(Pageable pageable) {
        return cardBlockRequestRepository.findAll(pageable)
                .map(mapper::mapToDto);
    }


    @Transactional(readOnly = true)
    public Page<CardBlockRequestDto> getBlockRequestsByStatus(String status, Pageable pageable) {
        return cardBlockRequestRepository.findByStatus(status, pageable)
                .map(mapper::mapToDto);
    }


    @Transactional(readOnly = true)
    public Page<CardBlockRequestDto> getUserBlockRequests(Long userId, Pageable pageable) {
        return cardBlockRequestRepository.findByUserId(userId, pageable)
                .map(mapper::mapToDto);
    }


    public CardBlockRequestDto getBlockRequestById(Long id) {
        return cardBlockRequestRepository.findById(id)
                .map(mapper::mapToDto)
                .orElseThrow(()-> new NoSuchElementException("Запрос на блокировку не найден"));
    }
}